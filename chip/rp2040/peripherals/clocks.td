// clocks.td - RP2040 Clock Controller

#ifndef _RP2040_CLOCKS_TD
#define _RP2040_CLOCKS_TD

include "base.td"

def ClocksPeripheral : PeripheralType<"CLOCKS", "Clock Controller"> {
  let accessWidth = 32;
  let registers = [
    Register<"CLK_GPOUT0_CTRL", 0x00, 32, [
      Field<"AUXSRC", 5, 4, ReadWrite, "Clock source">,
      Field<"KILL", 10, 1, ReadWrite, "Kill clock">,
      Field<"ENABLE", 11, 1, ReadWrite, "Enable clock">,
      Field<"DC50", 12, 1, ReadWrite, "50% duty cycle">,
      Field<"PHASE", 16, 2, ReadWrite, "Phase shift">,
      Field<"NUDGE", 20, 1, ReadWrite, "Nudge">
    ], "GPOUT0 clock control">,
    Register<"CLK_GPOUT0_DIV", 0x04, 32, [
      Field<"FRAC", 0, 8, ReadWrite, "Fractional divider">,
      Field<"INT", 8, 24, ReadWrite, "Integer divider">
    ], "GPOUT0 clock divider">,
    Register<"CLK_GPOUT0_SELECTED", 0x08, 32, [], "GPOUT0 selected clock">,
    Register<"CLK_REF_CTRL", 0x30, 32, [
      Field<"SRC", 0, 2, ReadWrite, "Reference clock source">,
      Field<"AUXSRC", 5, 2, ReadWrite, "Auxiliary clock source">
    ], "Reference clock control">,
    Register<"CLK_REF_DIV", 0x34, 32, [], "Reference clock divider">,
    Register<"CLK_REF_SELECTED", 0x38, 32, [], "Reference clock selected">,
    Register<"CLK_SYS_CTRL", 0x3C, 32, [
      Field<"SRC", 0, 1, ReadWrite, "System clock source">,
      Field<"AUXSRC", 5, 3, ReadWrite, "Auxiliary clock source">
    ], "System clock control">,
    Register<"CLK_SYS_DIV", 0x40, 32, [
      Field<"FRAC", 0, 8, ReadWrite, "Fractional divider">,
      Field<"INT", 8, 24, ReadWrite, "Integer divider">
    ], "System clock divider">,
    Register<"CLK_SYS_SELECTED", 0x44, 32, [], "System clock selected">,
    Register<"CLK_PERI_CTRL", 0x48, 32, [
      Field<"AUXSRC", 5, 3, ReadWrite, "Auxiliary clock source">,
      Field<"KILL", 10, 1, ReadWrite, "Kill clock">,
      Field<"ENABLE", 11, 1, ReadWrite, "Enable clock">
    ], "Peripheral clock control">,
    Register<"CLK_USB_CTRL", 0x54, 32, [
      Field<"AUXSRC", 5, 3, ReadWrite, "Auxiliary clock source">,
      Field<"KILL", 10, 1, ReadWrite, "Kill clock">,
      Field<"ENABLE", 11, 1, ReadWrite, "Enable clock">,
      Field<"PHASE", 16, 2, ReadWrite, "Phase shift">,
      Field<"NUDGE", 20, 1, ReadWrite, "Nudge">
    ], "USB clock control">,
    Register<"CLK_USB_DIV", 0x58, 32, [], "USB clock divider">,
    Register<"CLK_USB_SELECTED", 0x5C, 32, [], "USB clock selected">,
    Register<"CLK_ADC_CTRL", 0x60, 32, [
      Field<"AUXSRC", 5, 3, ReadWrite, "Auxiliary clock source">,
      Field<"KILL", 10, 1, ReadWrite, "Kill clock">,
      Field<"ENABLE", 11, 1, ReadWrite, "Enable clock">,
      Field<"PHASE", 16, 2, ReadWrite, "Phase shift">,
      Field<"NUDGE", 20, 1, ReadWrite, "Nudge">
    ], "ADC clock control">,
    Register<"CLK_ADC_DIV", 0x64, 32, [], "ADC clock divider">,
    Register<"CLK_ADC_SELECTED", 0x68, 32, [], "ADC clock selected">,
    Register<"CLK_RTC_CTRL", 0x6C, 32, [
      Field<"AUXSRC", 5, 3, ReadWrite, "Auxiliary clock source">,
      Field<"KILL", 10, 1, ReadWrite, "Kill clock">,
      Field<"ENABLE", 11, 1, ReadWrite, "Enable clock">,
      Field<"PHASE", 16, 2, ReadWrite, "Phase shift">,
      Field<"NUDGE", 20, 1, ReadWrite, "Nudge">
    ], "RTC clock control">,
    Register<"CLK_RTC_DIV", 0x70, 32, [], "RTC clock divider">,
    Register<"CLK_RTC_SELECTED", 0x74, 32, [], "RTC clock selected">
  ];
}

class ClocksInstance<string Name, int Base> : PeripheralInstance<Name, Base, ClocksPeripheral>;
def CLOCKS : ClocksInstance<"CLOCKS", 0x40008000>;

#endif // _RP2040_CLOCKS_TD
