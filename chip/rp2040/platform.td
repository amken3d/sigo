#ifndef _RP2040_TD
#define _RP2040_TD

include "base.td"
include "arm/cortexm/interrupts.td"
include "arm/cortexm/registers.td"
include "arm/cortexm/variant.td"
include "arm/family.td"

//===----------------------------------------------------------------------===//
// RP2040 Interrupts (26 device-specific IRQs)
//===----------------------------------------------------------------------===//

defvar rp2040_interrupts = [
  Interrupt<"TIMER_IRQ_0", 0, "Timer 0 interrupt">,
  Interrupt<"TIMER_IRQ_1", 1, "Timer 1 interrupt">,
  Interrupt<"TIMER_IRQ_2", 2, "Timer 2 interrupt">,
  Interrupt<"TIMER_IRQ_3", 3, "Timer 3 interrupt">,
  Interrupt<"PWM_IRQ_WRAP", 4, "PWM wrap interrupt">,
  Interrupt<"USBCTRL_IRQ", 5, "USB controller interrupt">,
  Interrupt<"XIP_IRQ", 6, "XIP interrupt">,
  Interrupt<"PIO0_IRQ_0", 7, "PIO0 interrupt 0">,
  Interrupt<"PIO0_IRQ_1", 8, "PIO0 interrupt 1">,
  Interrupt<"PIO1_IRQ_0", 9, "PIO1 interrupt 0">,
  Interrupt<"PIO1_IRQ_1", 10, "PIO1 interrupt 1">,
  Interrupt<"DMA_IRQ_0", 11, "DMA interrupt 0">,
  Interrupt<"DMA_IRQ_1", 12, "DMA interrupt 1">,
  Interrupt<"IO_IRQ_BANK0", 13, "GPIO Bank 0 interrupt">,
  Interrupt<"IO_IRQ_QSPI", 14, "QSPI interrupt">,
  Interrupt<"SIO_IRQ_PROC0", 15, "SIO processor 0 FIFO interrupt">,
  Interrupt<"SIO_IRQ_PROC1", 16, "SIO processor 1 FIFO interrupt">,
  Interrupt<"CLOCKS_IRQ", 17, "Clocks interrupt">,
  Interrupt<"SPI0_IRQ", 18, "SPI0 interrupt">,
  Interrupt<"SPI1_IRQ", 19, "SPI1 interrupt">,
  Interrupt<"UART0_IRQ", 20, "UART0 interrupt">,
  Interrupt<"UART1_IRQ", 21, "UART1 interrupt">,
  Interrupt<"ADC_IRQ_FIFO", 22, "ADC FIFO interrupt">,
  Interrupt<"I2C0_IRQ", 23, "I2C0 interrupt">,
  Interrupt<"I2C1_IRQ", 24, "I2C1 interrupt">,
  Interrupt<"RTC_IRQ", 25, "RTC interrupt">,
];

defvar rp2040_tags = ["rp2040", "rp", "pico"];

//===----------------------------------------------------------------------===//
// RP2040 Memory Definitions
// Note: Flash offset starts at 0x10000100 to account for 256-byte boot2 bootloader
//===----------------------------------------------------------------------===//

def RP2040_FLASH : MemoryRange<"FLASH", 0x10000100, KB<2048>, Executable, ReadWrite, "XIP Flash (2MB, after boot2)">;
def RP2040_SRAM : MemoryRange<"SRAM", 0x20000000, KB<264>, false, ReadWrite, "Main SRAM (264KB)">;

defvar rp2040_memories = [
    RP2040_FLASH,
    RP2040_SRAM,
];

//===----------------------------------------------------------------------===//
// RP2040 Variant Base Class
//===----------------------------------------------------------------------===//

class RP2040Variant<string Name, list<MemoryRange> Memories, MemoryUnit StackSize,
                    list<string> Tags = [], string Description = "">
    : CortexMVariant<Name, Memories, rp2040_interrupts, StackSize,
                     !listconcat(rp2040_tags, Tags), Description>;

//===----------------------------------------------------------------------===//
// RP2040 Variants
//===----------------------------------------------------------------------===//

// RP2040 Memory Map:
// 0x00000000 - ROM (16KB bootrom)
// 0x10000000 - XIP Flash (up to 16MB addressable, external QSPI)
// 0x20000000 - SRAM (264KB in 6 banks: 4x64KB striped + 2x4KB)
// 0x40000000 - APB Peripherals
// 0x50000000 - AHB-Lite Peripherals
// 0xD0000000 - SIO (Single-cycle I/O)
// 0xE0000000 - Cortex-M0+ internal

def RP2040 : RP2040Variant<"rp2040", rp2040_memories, KB<2>, [], "Raspberry Pi RP2040">;

def PICO : RP2040Variant<"pico", rp2040_memories, KB<2>, ["pico_board"], "Raspberry Pi Pico">;

def PICO_W : RP2040Variant<"pico_w", rp2040_memories, KB<2>, ["pico_w_board", "wifi"], "Raspberry Pi Pico W">;

//===----------------------------------------------------------------------===//
// RP2040 Series Definition
//===----------------------------------------------------------------------===//

def RP2040Series : Series<"RP2040", CortexM0Plus> {
  let variants = [RP2040, PICO, PICO_W];
  let peripheralTypes = [];
  let runtimePackages = ["pkg.si-go.dev/chip/rp2040"];
}

#endif // _RP2040_TD
