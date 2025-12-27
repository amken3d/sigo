# SiGo vs TinyGo Benchmarks

This benchmark suite compares SiGo and TinyGo across multiple dimensions.

## Benchmarks

| Benchmark | Description | Measures |
|-----------|-------------|----------|
| `minimal` | Empty main function | Minimum binary size |
| `blinky` | GPIO toggle loop | Basic I/O, code size |
| `compute/fib` | Recursive Fibonacci | Function calls, recursion |
| `compute/sieve` | Sieve of Eratosthenes | Arrays, loops |
| `compute/sort` | Quicksort on slices | Slices, memory |
| `concurrency/goroutines` | Spawn goroutines | Scheduler overhead |
| `concurrency/channels` | Producer-consumer | Channel performance |
| `io/uart` | Serial I/O | Peripheral access |

## Running Benchmarks

### Prerequisites

```bash
# Install TinyGo
# See: https://tinygo.org/getting-started/install/

# Build SiGo
cd /path/to/sigo
make sigo
```

### Quick Run

```bash
./benchmarks/run.sh
```

### Manual Run

```bash
# Build with both compilers
tinygo build -o out/minimal-tinygo.elf -target=pico ./benchmarks/minimal
./bin/sigoc build --cpu rp2040 -o out/minimal-sigo.elf ./benchmarks/minimal

# Compare sizes
arm-none-eabi-size out/minimal-tinygo.elf out/minimal-sigo.elf
```

## Metrics

### Binary Size
```bash
arm-none-eabi-size -A firmware.elf
```

### Compilation Time
```bash
hyperfine 'tinygo build ...' 'sigoc build ...'
```

### Runtime Performance
Use the cycle counter or logic analyzer to measure execution time on device.

## Results

Results are written to `results/` directory in CSV format for analysis.
