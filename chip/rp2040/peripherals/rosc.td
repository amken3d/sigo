// rosc.td - RP2040 Ring Oscillator

#ifndef _RP2040_ROSC_TD
#define _RP2040_ROSC_TD

include "base.td"

def ROSCPeripheral : PeripheralType<"ROSC", "Ring Oscillator"> {
  let accessWidth = 32;
  let registers = [
    Register<"CTRL", 0x00, 32, [
      Field<"FREQ_RANGE", 0, 12, ReadWrite, "Frequency range">,
      Field<"ENABLE", 12, 12, ReadWrite, "Enable">
    ], "Control">,
    Register<"FREQA", 0x04, 32, [
      Field<"DS0", 0, 3, ReadWrite, "Drive strength 0">,
      Field<"DS1", 4, 3, ReadWrite, "Drive strength 1">,
      Field<"DS2", 8, 3, ReadWrite, "Drive strength 2">,
      Field<"DS3", 12, 3, ReadWrite, "Drive strength 3">,
      Field<"PASSWD", 16, 16, ReadWrite, "Password">
    ], "Frequency A">,
    Register<"FREQB", 0x08, 32, [
      Field<"DS4", 0, 3, ReadWrite, "Drive strength 4">,
      Field<"DS5", 4, 3, ReadWrite, "Drive strength 5">,
      Field<"DS6", 8, 3, ReadWrite, "Drive strength 6">,
      Field<"DS7", 12, 3, ReadWrite, "Drive strength 7">,
      Field<"PASSWD", 16, 16, ReadWrite, "Password">
    ], "Frequency B">,
    Register<"DORMANT", 0x0C, 32, [], "Dormant control">,
    Register<"DIV", 0x10, 32, [
      Field<"DIV", 0, 12, ReadWrite, "Divider">
    ], "Divider">,
    Register<"PHASE", 0x14, 32, [
      Field<"SHIFT", 0, 2, ReadWrite, "Phase shift">,
      Field<"FLIP", 2, 1, ReadWrite, "Phase flip">,
      Field<"ENABLE", 3, 1, ReadWrite, "Phase enable">,
      Field<"PASSWD", 4, 8, ReadWrite, "Password">
    ], "Phase">,
    Register<"STATUS", 0x18, 32, [
      Field<"ENABLED", 12, 1, Read, "Oscillator enabled">,
      Field<"DIV_RUNNING", 16, 1, Read, "Divider running">,
      Field<"BADWRITE", 24, 1, ReadWrite, "Bad write">,
      Field<"STABLE", 31, 1, Read, "Oscillator stable">
    ], "Status">,
    Register<"RANDOMBIT", 0x1C, 32, [
      Field<"RANDOMBIT", 0, 1, Read, "Random bit">
    ], "Random bit">,
    Register<"COUNT", 0x20, 32, [
      Field<"COUNT", 0, 8, ReadWrite, "Count">
    ], "Count">
  ];
}

class ROSCInstance<string Name, int Base> : PeripheralInstance<Name, Base, ROSCPeripheral>;
def ROSC : ROSCInstance<"ROSC", 0x40060000>;

#endif // _RP2040_ROSC_TD
