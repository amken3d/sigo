// platform.td - RP2040 Series Platform Definition
// Raspberry Pi RP2040 - Dual-core ARM Cortex-M0+ @ 133MHz

#ifndef _RP2040_TD
#define _RP2040_TD

include "base.td"
include "arm/cortexm/interrupts.td"
include "arm/cortexm/registers.td"
include "arm/cortexm/variant.td"
include "arm/family.td"

// Include peripheral definitions
include "peripherals/resets.td"
include "peripherals/clocks.td"
include "peripherals/gpio.td"
include "peripherals/uart.td"
include "peripherals/spi.td"
include "peripherals/i2c.td"
include "peripherals/pwm.td"
include "peripherals/timer.td"
include "peripherals/adc.td"
include "peripherals/pio.td"
include "peripherals/sio.td"
include "peripherals/pads.td"
include "peripherals/xosc.td"
include "peripherals/pll.td"
include "peripherals/rosc.td"
include "peripherals/watchdog.td"

//===----------------------------------------------------------------------===//
// Peripheral Types List
//===----------------------------------------------------------------------===//

defvar peripherals = [
  ResetsPeripheral,
  ClocksPeripheral,
  GPIOPeripheral,
  UARTPeripheral,
  SPIPeripheral,
  I2CPeripheral,
  PWMPeripheral,
  TimerPeripheral,
  ADCPeripheral,
  PIOPeripheral,
  SIOPeripheral,
  PadsPeripheral,
  XOSCPeripheral,
  PLLPeripheral,
  ROSCPeripheral,
  WatchdogPeripheral,
];

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
// RP2040 Variant Base Class
//===----------------------------------------------------------------------===//

class RP2040Variant<string name, list<MemoryRange> memories, MemoryUnit stackSize,
                    list<string> tags = [], string description = "">
    : CortexMVariant<name, memories, rp2040_interrupts, stackSize,
                     !listconcat(rp2040_tags, tags), description>;

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

// Note: Flash starts at 0x10000100 to account for 256-byte boot2 bootloader
def RP2040 : RP2040Variant<"rp2040", [
    MemoryRange<"FLASH", 0x10000100, 2097152 - 256, ReadExec, true,
                "XIP Flash (after boot2, up to 16MB)">,
    MemoryRange<"SRAM", 0x20000000, 270336, ReadWrite, false,
                "Main SRAM (264KB)">,
  ],
  KB<2>,
  [],
  "Raspberry Pi RP2040">;

// Raspberry Pi Pico - 2MB flash variant
def PICO : RP2040Variant<"pico", [
    MemoryRange<"FLASH", 0x10000100, 2097152 - 256, ReadExec, true,
                "2MB XIP Flash (W25Q16)">,
    MemoryRange<"SRAM", 0x20000000, 270336, ReadWrite, false,
                "264KB SRAM">,
  ],
  KB<2>,
  ["pico_board"],
  "Raspberry Pi Pico">;

// Raspberry Pi Pico W - 2MB flash with WiFi
def PICO_W : RP2040Variant<"pico_w", [
    MemoryRange<"FLASH", 0x10000100, 2097152 - 256, ReadExec, true,
                "2MB XIP Flash">,
    MemoryRange<"SRAM", 0x20000000, 270336, ReadWrite, false,
                "264KB SRAM">,
  ],
  KB<2>,
  ["pico_w_board", "wifi"],
  "Raspberry Pi Pico W">;

//===----------------------------------------------------------------------===//
// RP2040 Series Definition
//===----------------------------------------------------------------------===//

def RP2040Series : Series<"RP2040", CortexM0Plus> {
  let variants = [RP2040, PICO, PICO_W];
  let peripheralTypes = peripherals;
  let runtimePackages = ["pkg.si-go.dev/chip/rp2040/runtime"];
}

#endif // _RP2040_TD
