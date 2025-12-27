#!/bin/bash
# SiGo vs TinyGo Benchmark Runner
# Compiles all benchmarks with both compilers and compares results.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIGO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$SCRIPT_DIR/out"
RESULTS_DIR="$SCRIPT_DIR/results"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Compiler paths
SIGOC="${SIGO_ROOT}/bin/sigoc"
TINYGO="tinygo"

# Target
TARGET_SIGO="rp2040"
TARGET_TINYGO="pico"

# Benchmarks to run
BENCHMARKS=(
    "minimal"
    "blinky"
    "compute/fib"
    "compute/sieve"
    "compute/sort"
    "concurrency/goroutines"
    "concurrency/channels"
)

# Check dependencies
check_deps() {
    echo -e "${BLUE}Checking dependencies...${NC}"

    if ! command -v arm-none-eabi-size &> /dev/null; then
        echo -e "${RED}Error: arm-none-eabi-size not found${NC}"
        echo "Install with: apt install gcc-arm-none-eabi"
        exit 1
    fi

    if ! command -v $TINYGO &> /dev/null; then
        echo -e "${YELLOW}Warning: TinyGo not found, will only run SiGo benchmarks${NC}"
        TINYGO=""
    fi

    if [[ ! -f "$SIGOC" ]]; then
        echo -e "${YELLOW}Warning: SiGo not found at $SIGOC, will only run TinyGo benchmarks${NC}"
        SIGOC=""
    fi

    if [[ -z "$SIGOC" && -z "$TINYGO" ]]; then
        echo -e "${RED}Error: Neither SiGo nor TinyGo found${NC}"
        exit 1
    fi
}

# Create output directories
setup() {
    mkdir -p "$OUT_DIR"
    mkdir -p "$RESULTS_DIR"
}

# Build benchmark with SiGo
build_sigo() {
    local bench="$1"
    local name=$(echo "$bench" | tr '/' '-')
    local out="$OUT_DIR/${name}-sigo.elf"

    if [[ -z "$SIGOC" ]]; then
        return 1
    fi

    echo -n "  SiGo: "
    if $SIGOC build --cpu "$TARGET_SIGO" -o "$out" "$SCRIPT_DIR/$bench" 2>/dev/null; then
        echo -e "${GREEN}OK${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Build benchmark with TinyGo
build_tinygo() {
    local bench="$1"
    local name=$(echo "$bench" | tr '/' '-')
    local out="$OUT_DIR/${name}-tinygo.elf"

    if [[ -z "$TINYGO" ]]; then
        return 1
    fi

    echo -n "  TinyGo: "
    if $TINYGO build -o "$out" -target="$TARGET_TINYGO" "$SCRIPT_DIR/$bench" 2>/dev/null; then
        echo -e "${GREEN}OK${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        return 1
    fi
}

# Get size of ELF sections
get_size() {
    local elf="$1"
    if [[ -f "$elf" ]]; then
        arm-none-eabi-size "$elf" | tail -1 | awk '{print $1, $2, $3, $4}'
    else
        echo "- - - -"
    fi
}

# Get compile time
time_build() {
    local cmd="$1"
    local start=$(date +%s%N)
    eval "$cmd" &>/dev/null
    local end=$(date +%s%N)
    echo $(( (end - start) / 1000000 ))  # milliseconds
}

# Run all benchmarks
run_benchmarks() {
    echo -e "${BLUE}Running benchmarks...${NC}"
    echo ""

    # CSV header
    echo "benchmark,compiler,text,data,bss,total,compile_ms" > "$RESULTS_DIR/results.csv"

    for bench in "${BENCHMARKS[@]}"; do
        echo -e "${YELLOW}Benchmark: $bench${NC}"
        local name=$(echo "$bench" | tr '/' '-')

        # Build with SiGo
        if build_sigo "$bench"; then
            local sigo_elf="$OUT_DIR/${name}-sigo.elf"
            local sigo_size=$(get_size "$sigo_elf")
            local sigo_time=$(time_build "$SIGOC build --cpu $TARGET_SIGO -o /dev/null $SCRIPT_DIR/$bench")
            echo "$bench,sigo,$sigo_size,$sigo_time" >> "$RESULTS_DIR/results.csv"
        fi

        # Build with TinyGo
        if build_tinygo "$bench"; then
            local tinygo_elf="$OUT_DIR/${name}-tinygo.elf"
            local tinygo_size=$(get_size "$tinygo_elf")
            local tinygo_time=$(time_build "$TINYGO build -o /dev/null -target=$TARGET_TINYGO $SCRIPT_DIR/$bench")
            echo "$bench,tinygo,$tinygo_size,$tinygo_time" >> "$RESULTS_DIR/results.csv"
        fi

        echo ""
    done
}

# Print summary table
print_summary() {
    echo -e "${BLUE}=== Summary ===${NC}"
    echo ""
    printf "%-25s %10s %10s %10s %10s\n" "Benchmark" "SiGo" "TinyGo" "Diff" "Winner"
    printf "%-25s %10s %10s %10s %10s\n" "---------" "----" "------" "----" "------"

    for bench in "${BENCHMARKS[@]}"; do
        local name=$(echo "$bench" | tr '/' '-')
        local sigo_elf="$OUT_DIR/${name}-sigo.elf"
        local tinygo_elf="$OUT_DIR/${name}-tinygo.elf"

        local sigo_total="-"
        local tinygo_total="-"

        if [[ -f "$sigo_elf" ]]; then
            sigo_total=$(arm-none-eabi-size "$sigo_elf" 2>/dev/null | tail -1 | awk '{print $4}')
        fi

        if [[ -f "$tinygo_elf" ]]; then
            tinygo_total=$(arm-none-eabi-size "$tinygo_elf" 2>/dev/null | tail -1 | awk '{print $4}')
        fi

        local diff="-"
        local winner="-"

        if [[ "$sigo_total" != "-" && "$tinygo_total" != "-" ]]; then
            diff=$((tinygo_total - sigo_total))
            if [[ $diff -gt 0 ]]; then
                winner="SiGo"
                diff="+$diff"
            elif [[ $diff -lt 0 ]]; then
                winner="TinyGo"
            else
                winner="Tie"
            fi
        elif [[ "$sigo_total" != "-" ]]; then
            winner="SiGo (only)"
        elif [[ "$tinygo_total" != "-" ]]; then
            winner="TinyGo (only)"
        fi

        printf "%-25s %10s %10s %10s %10s\n" "$bench" "$sigo_total" "$tinygo_total" "$diff" "$winner"
    done

    echo ""
    echo -e "Results saved to: ${GREEN}$RESULTS_DIR/results.csv${NC}"
}

# Main
main() {
    echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     SiGo vs TinyGo Benchmark Suite    ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
    echo ""

    check_deps
    setup
    run_benchmarks
    print_summary
}

main "$@"
