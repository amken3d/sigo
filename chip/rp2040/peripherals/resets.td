// resets.td - RP2040 Reset Controller

#ifndef _RP2040_RESETS_TD
#define _RP2040_RESETS_TD

include "base.td"

def ResetsPeripheral : PeripheralType<"RESETS", "Reset Controller"> {
  let accessWidth = 32;
  let registers = [
    Register<"RESET", 0x00, 32, [
      Field<"ADC", 0, 1, ReadWrite, "ADC reset">,
      Field<"BUSCTRL", 1, 1, ReadWrite, "Bus control reset">,
      Field<"DMA", 2, 1, ReadWrite, "DMA reset">,
      Field<"I2C0", 3, 1, ReadWrite, "I2C0 reset">,
      Field<"I2C1", 4, 1, ReadWrite, "I2C1 reset">,
      Field<"IO_BANK0", 5, 1, ReadWrite, "IO Bank 0 reset">,
      Field<"IO_QSPI", 6, 1, ReadWrite, "IO QSPI reset">,
      Field<"JTAG", 7, 1, ReadWrite, "JTAG reset">,
      Field<"PADS_BANK0", 8, 1, ReadWrite, "Pads Bank 0 reset">,
      Field<"PADS_QSPI", 9, 1, ReadWrite, "Pads QSPI reset">,
      Field<"PIO0", 10, 1, ReadWrite, "PIO0 reset">,
      Field<"PIO1", 11, 1, ReadWrite, "PIO1 reset">,
      Field<"PLL_SYS", 12, 1, ReadWrite, "PLL SYS reset">,
      Field<"PLL_USB", 13, 1, ReadWrite, "PLL USB reset">,
      Field<"PWM", 14, 1, ReadWrite, "PWM reset">,
      Field<"RTC", 15, 1, ReadWrite, "RTC reset">,
      Field<"SPI0", 16, 1, ReadWrite, "SPI0 reset">,
      Field<"SPI1", 17, 1, ReadWrite, "SPI1 reset">,
      Field<"SYSCFG", 18, 1, ReadWrite, "SYSCFG reset">,
      Field<"SYSINFO", 19, 1, ReadWrite, "SYSINFO reset">,
      Field<"TBMAN", 20, 1, ReadWrite, "TBMAN reset">,
      Field<"TIMER", 21, 1, ReadWrite, "Timer reset">,
      Field<"UART0", 22, 1, ReadWrite, "UART0 reset">,
      Field<"UART1", 23, 1, ReadWrite, "UART1 reset">,
      Field<"USBCTRL", 24, 1, ReadWrite, "USB controller reset">
    ], "Reset control">,
    Register<"WDSEL", 0x04, 32, [], "Watchdog select">,
    Register<"RESET_DONE", 0x08, 32, [], "Reset done status">
  ];
}

class ResetsInstance<string Name, int Base> : PeripheralInstance<Name, Base, ResetsPeripheral>;
def RESETS : ResetsInstance<"RESETS", 0x4000C000>;

#endif // _RP2040_RESETS_TD
