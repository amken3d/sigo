// xosc.td - RP2040 Crystal Oscillator

#ifndef _RP2040_XOSC_TD
#define _RP2040_XOSC_TD

include "base.td"

def XOSCPeripheral : PeripheralType<"XOSC", "Crystal Oscillator"> {
  let accessWidth = 32;
  let registers = [
    Register<"CTRL", 0x00, 32, [
      Field<"FREQ_RANGE", 0, 12, ReadWrite, "Frequency range", [
        Enum<"1_15MHZ", 0xAA0, "1-15 MHz">,
        Enum<"10_30MHZ", 0xAA1, "10-30 MHz">,
        Enum<"25_60MHZ", 0xAA2, "25-60 MHz">,
        Enum<"40_100MHZ", 0xAA3, "40-100 MHz">
      ]>,
      Field<"ENABLE", 12, 12, ReadWrite, "Enable", [
        Enum<"DISABLE", 0xD1E, "Disable">,
        Enum<"ENABLE", 0xFAB, "Enable">
      ]>
    ], "Control">,
    Register<"STATUS", 0x04, 32, [
      Field<"FREQ_RANGE", 0, 2, Read, "Frequency range">,
      Field<"ENABLED", 12, 1, Read, "Oscillator enabled">,
      Field<"BADWRITE", 24, 1, ReadWrite, "Bad write">,
      Field<"STABLE", 31, 1, Read, "Oscillator stable">
    ], "Status">,
    Register<"DORMANT", 0x08, 32, [], "Dormant control">,
    Register<"STARTUP", 0x0C, 32, [
      Field<"DELAY", 0, 14, ReadWrite, "Startup delay">,
      Field<"X4", 20, 1, ReadWrite, "Multiply delay by 4">
    ], "Startup delay">,
    Register<"COUNT", 0x1C, 32, [
      Field<"COUNT", 0, 8, ReadWrite, "Counter">
    ], "Count">
  ];
}

class XOSCInstance<string Name, int Base> : PeripheralInstance<Name, Base, XOSCPeripheral>;
def XOSC : XOSCInstance<"XOSC", 0x40024000>;

#endif // _RP2040_XOSC_TD
