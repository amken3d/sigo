// platform.td - RP2350 Series Platform Definition
// Raspberry Pi RP2350 - Dual-core ARM Cortex-M33 @ 150MHz

#ifndef _RP2350_TD
#define _RP2350_TD

include "base.td"
include "arm/cortexm/interrupts.td"
include "arm/cortexm/registers.td"
include "arm/cortexm/variant.td"
include "arm/family.td"

// Include peripheral definitions (shared with RP2040 where compatible)
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
  WatchdogPeripheral,
];

//===----------------------------------------------------------------------===//
// RP2350 Interrupts (52 device-specific IRQs)
//===----------------------------------------------------------------------===//

defvar rp2350_interrupts = [
  Interrupt<"TIMER0_IRQ_0", 0, "Timer 0 interrupt 0">,
  Interrupt<"TIMER0_IRQ_1", 1, "Timer 0 interrupt 1">,
  Interrupt<"TIMER0_IRQ_2", 2, "Timer 0 interrupt 2">,
  Interrupt<"TIMER0_IRQ_3", 3, "Timer 0 interrupt 3">,
  Interrupt<"TIMER1_IRQ_0", 4, "Timer 1 interrupt 0">,
  Interrupt<"TIMER1_IRQ_1", 5, "Timer 1 interrupt 1">,
  Interrupt<"TIMER1_IRQ_2", 6, "Timer 1 interrupt 2">,
  Interrupt<"TIMER1_IRQ_3", 7, "Timer 1 interrupt 3">,
  Interrupt<"PWM_IRQ_WRAP_0", 8, "PWM wrap 0 interrupt">,
  Interrupt<"PWM_IRQ_WRAP_1", 9, "PWM wrap 1 interrupt">,
  Interrupt<"DMA_IRQ_0", 10, "DMA interrupt 0">,
  Interrupt<"DMA_IRQ_1", 11, "DMA interrupt 1">,
  Interrupt<"DMA_IRQ_2", 12, "DMA interrupt 2">,
  Interrupt<"DMA_IRQ_3", 13, "DMA interrupt 3">,
  Interrupt<"USBCTRL_IRQ", 14, "USB controller interrupt">,
  Interrupt<"PIO0_IRQ_0", 15, "PIO0 interrupt 0">,
  Interrupt<"PIO0_IRQ_1", 16, "PIO0 interrupt 1">,
  Interrupt<"PIO1_IRQ_0", 17, "PIO1 interrupt 0">,
  Interrupt<"PIO1_IRQ_1", 18, "PIO1 interrupt 1">,
  Interrupt<"PIO2_IRQ_0", 19, "PIO2 interrupt 0">,
  Interrupt<"PIO2_IRQ_1", 20, "PIO2 interrupt 1">,
  Interrupt<"IO_IRQ_BANK0", 21, "GPIO Bank 0 interrupt">,
  Interrupt<"IO_IRQ_BANK0_NS", 22, "GPIO Bank 0 non-secure interrupt">,
  Interrupt<"IO_IRQ_QSPI", 23, "QSPI interrupt">,
  Interrupt<"IO_IRQ_QSPI_NS", 24, "QSPI non-secure interrupt">,
  Interrupt<"SIO_IRQ_FIFO", 25, "SIO FIFO interrupt">,
  Interrupt<"SIO_IRQ_BELL", 26, "SIO doorbell interrupt">,
  Interrupt<"SIO_IRQ_FIFO_NS", 27, "SIO FIFO non-secure interrupt">,
  Interrupt<"SIO_IRQ_BELL_NS", 28, "SIO doorbell non-secure interrupt">,
  Interrupt<"SIO_IRQ_MTIMECMP", 29, "SIO MTIMECMP interrupt">,
  Interrupt<"CLOCKS_IRQ", 30, "Clocks interrupt">,
  Interrupt<"SPI0_IRQ", 31, "SPI0 interrupt">,
  Interrupt<"SPI1_IRQ", 32, "SPI1 interrupt">,
  Interrupt<"UART0_IRQ", 33, "UART0 interrupt">,
  Interrupt<"UART1_IRQ", 34, "UART1 interrupt">,
  Interrupt<"ADC_IRQ_FIFO", 35, "ADC FIFO interrupt">,
  Interrupt<"I2C0_IRQ", 36, "I2C0 interrupt">,
  Interrupt<"I2C1_IRQ", 37, "I2C1 interrupt">,
  Interrupt<"OTP_IRQ", 38, "OTP interrupt">,
  Interrupt<"TRNG_IRQ", 39, "TRNG interrupt">,
  Interrupt<"PROC0_IRQ_CTI", 40, "Processor 0 CTI interrupt">,
  Interrupt<"PROC1_IRQ_CTI", 41, "Processor 1 CTI interrupt">,
  Interrupt<"PLL_SYS_IRQ", 42, "PLL SYS interrupt">,
  Interrupt<"PLL_USB_IRQ", 43, "PLL USB interrupt">,
  Interrupt<"POWMAN_IRQ_POW", 44, "Power manager power interrupt">,
  Interrupt<"POWMAN_IRQ_TIMER", 45, "Power manager timer interrupt">,
  Interrupt<"SPAREIRQ_IRQ_0", 46, "Spare IRQ 0">,
  Interrupt<"SPAREIRQ_IRQ_1", 47, "Spare IRQ 1">,
  Interrupt<"SPAREIRQ_IRQ_2", 48, "Spare IRQ 2">,
  Interrupt<"SPAREIRQ_IRQ_3", 49, "Spare IRQ 3">,
  Interrupt<"SPAREIRQ_IRQ_4", 50, "Spare IRQ 4">,
  Interrupt<"SPAREIRQ_IRQ_5", 51, "Spare IRQ 5">,
];

defvar rp2350_tags = ["rp2350", "rp", "pico2"];

//===----------------------------------------------------------------------===//
// RP2350 Variant Base Class
//===----------------------------------------------------------------------===//

class RP2350Variant<string name, list<MemoryRange> memories, MemoryUnit stackSize,
                    list<string> tags = [], string description = "">
    : CortexMVariant<name, memories, rp2350_interrupts, stackSize,
                     !listconcat(rp2350_tags, tags), description>;

//===----------------------------------------------------------------------===//
// RP2350 Variants
//===----------------------------------------------------------------------===//

// RP2350 Memory Map:
// 0x00000000 - ROM (32KB bootrom)
// 0x10000000 - XIP Flash (up to 16MB addressable, external QSPI)
// 0x20000000 - SRAM (520KB in multiple banks)
// 0x40000000 - APB Peripherals
// 0x50000000 - AHB-Lite Peripherals
// 0xD0000000 - SIO (Single-cycle I/O)
// 0xE0000000 - Cortex-M33 internal

// Note: Flash starts at 0x10000100 to account for 256-byte boot2 bootloader
def RP2350 : RP2350Variant<"rp2350", [
    MemoryRange<"FLASH", 0x10000100, 4194304 - 256, ReadExec, true,
                "XIP Flash (after boot2, up to 16MB)">,
    MemoryRange<"SRAM", 0x20000000, 532480, ReadWrite, false,
                "Main SRAM (520KB)">,
  ],
  KB<4>,
  [],
  "Raspberry Pi RP2350">;

// Raspberry Pi Pico 2 - 4MB flash variant
def PICO2 : RP2350Variant<"pico2", [
    MemoryRange<"FLASH", 0x10000100, 4194304 - 256, ReadExec, true,
                "4MB XIP Flash">,
    MemoryRange<"SRAM", 0x20000000, 532480, ReadWrite, false,
                "520KB SRAM">,
  ],
  KB<4>,
  ["pico2_board"],
  "Raspberry Pi Pico 2">;

// Raspberry Pi Pico 2 W - 4MB flash with WiFi
def PICO2_W : RP2350Variant<"pico2_w", [
    MemoryRange<"FLASH", 0x10000100, 4194304 - 256, ReadExec, true,
                "4MB XIP Flash">,
    MemoryRange<"SRAM", 0x20000000, 532480, ReadWrite, false,
                "520KB SRAM">,
  ],
  KB<4>,
  ["pico2_w_board", "wifi"],
  "Raspberry Pi Pico 2 W">;

//===----------------------------------------------------------------------===//
// RP2350 Series Definition
//===----------------------------------------------------------------------===//

def RP2350Series : Series<"RP2350", CortexM33> {
  let variants = [RP2350, PICO2, PICO2_W];
  let peripheralTypes = peripherals;
  let runtimePackages = ["pkg.si-go.dev/chip/rp2350/runtime"];
}

#endif // _RP2350_TD
