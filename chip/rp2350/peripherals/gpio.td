// gpio.td - RP2040 GPIO and IO Bank

#ifndef _RP2040_GPIO_TD
#define _RP2040_GPIO_TD

include "base.td"

def GPIOPeripheral : PeripheralType<"GPIO", "GPIO Bank 0"> {
  let accessWidth = 32;
  let count = 30;  // 30 GPIO pins (GPIO0-29)
  let arrayLabel = "GPIO";
  let registers = [
    Register<"STATUS", 0x00, 32, [
      Field<"OUTFROMPERI", 8, 1, Read, "Output from peripheral">,
      Field<"OUTTOPAD", 9, 1, Read, "Output to pad">,
      Field<"OEFROMPERI", 12, 1, Read, "Output enable from peripheral">,
      Field<"OETOPAD", 13, 1, Read, "Output enable to pad">,
      Field<"INFROMPAD", 17, 1, Read, "Input from pad">,
      Field<"INTOPERI", 19, 1, Read, "Input to peripheral">,
      Field<"IRQFROMPAD", 24, 1, Read, "IRQ from pad">,
      Field<"IRQTOPROC", 26, 1, Read, "IRQ to processor">
    ], "GPIO status">,
    Register<"CTRL", 0x04, 32, [
      Field<"FUNCSEL", 0, 5, ReadWrite, "Function select", [
        Enum<"XIP", 0, "XIP">,
        Enum<"SPI", 1, "SPI">,
        Enum<"UART", 2, "UART">,
        Enum<"I2C", 3, "I2C">,
        Enum<"PWM", 4, "PWM">,
        Enum<"SIO", 5, "SIO (GPIO)">,
        Enum<"PIO0", 6, "PIO0">,
        Enum<"PIO1", 7, "PIO1">,
        Enum<"GPCK", 8, "Clock">,
        Enum<"USB", 9, "USB">,
        Enum<"NULL", 31, "Null function">
      ]>,
      Field<"OUTOVER", 8, 2, ReadWrite, "Output override", [
        Enum<"NORMAL", 0, "Normal">,
        Enum<"INVERT", 1, "Invert">,
        Enum<"LOW", 2, "Drive low">,
        Enum<"HIGH", 3, "Drive high">
      ]>,
      Field<"OEOVER", 12, 2, ReadWrite, "Output enable override">,
      Field<"INOVER", 16, 2, ReadWrite, "Input override">,
      Field<"IRQOVER", 28, 2, ReadWrite, "IRQ override">
    ], "GPIO control">
  ];
}

class GPIOInstance<string Name, int Base> : PeripheralInstance<Name, Base, GPIOPeripheral>;
def IO_BANK0 : GPIOInstance<"IO_BANK0", 0x40014000>;

// Interrupt registers for GPIO bank
def GPIOINTRPeripheral : PeripheralType<"GPIO_INTR", "GPIO Interrupt Control"> {
  let accessWidth = 32;
  let registers = [
    RepeatingRegister<"INTR", 4, 0xF0, 32, [], "Raw interrupts">,
    RepeatingRegister<"PROC0_INTE", 4, 0x100, 32, [], "Interrupt enable for processor 0">,
    RepeatingRegister<"PROC0_INTF", 4, 0x110, 32, [], "Interrupt force for processor 0">,
    RepeatingRegister<"PROC0_INTS", 4, 0x120, 32, [], "Interrupt status for processor 0">,
    RepeatingRegister<"PROC1_INTE", 4, 0x130, 32, [], "Interrupt enable for processor 1">,
    RepeatingRegister<"PROC1_INTF", 4, 0x140, 32, [], "Interrupt force for processor 1">,
    RepeatingRegister<"PROC1_INTS", 4, 0x150, 32, [], "Interrupt status for processor 1">,
    RepeatingRegister<"DORMANT_WAKE_INTE", 4, 0x160, 32, [], "Dormant wake interrupt enable">,
    RepeatingRegister<"DORMANT_WAKE_INTF", 4, 0x170, 32, [], "Dormant wake interrupt force">,
    RepeatingRegister<"DORMANT_WAKE_INTS", 4, 0x180, 32, [], "Dormant wake interrupt status">
  ];
}

class GPIOINTRInstance<string Name, int Base> : PeripheralInstance<Name, Base, GPIOINTRPeripheral>;
def GPIO_INTR : GPIOINTRInstance<"GPIO_INTR", 0x40014000>;

#endif // _RP2040_GPIO_TD
