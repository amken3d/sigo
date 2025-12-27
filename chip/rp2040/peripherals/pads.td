// pads.td - RP2040 Pad Control

#ifndef _RP2040_PADS_TD
#define _RP2040_PADS_TD

include "base.td"

def PadsPeripheral : PeripheralType<"PADS", "Pad Control"> {
  let accessWidth = 32;
  let registers = [
    Register<"VOLTAGE_SELECT", 0x00, 32, [
      Field<"VOLTAGE_SELECT", 0, 1, ReadWrite, "Voltage select (0=3.3V, 1=1.8V)">
    ], "Voltage select">,
    // GPIO0-29 pad control registers
    RepeatingRegister<"GPIO", 30, 0x04, 32, [
      Field<"SLEWFAST", 0, 1, ReadWrite, "Slew rate fast">,
      Field<"SCHMITT", 1, 1, ReadWrite, "Schmitt trigger enable">,
      Field<"PDE", 2, 1, ReadWrite, "Pull-down enable">,
      Field<"PUE", 3, 1, ReadWrite, "Pull-up enable">,
      Field<"DRIVE", 4, 2, ReadWrite, "Drive strength", [
        Enum<"DRIVE_2MA", 0, "2mA">,
        Enum<"DRIVE_4MA", 1, "4mA">,
        Enum<"DRIVE_8MA", 2, "8mA">,
        Enum<"DRIVE_12MA", 3, "12mA">
      ]>,
      Field<"IE", 6, 1, ReadWrite, "Input enable">,
      Field<"OD", 7, 1, ReadWrite, "Output disable">
    ], "GPIO pad control">,
    Register<"SWCLK", 0x7C, 32, [
      Field<"SLEWFAST", 0, 1, ReadWrite, "Slew rate fast">,
      Field<"SCHMITT", 1, 1, ReadWrite, "Schmitt trigger enable">,
      Field<"PDE", 2, 1, ReadWrite, "Pull-down enable">,
      Field<"PUE", 3, 1, ReadWrite, "Pull-up enable">,
      Field<"DRIVE", 4, 2, ReadWrite, "Drive strength">,
      Field<"IE", 6, 1, ReadWrite, "Input enable">,
      Field<"OD", 7, 1, ReadWrite, "Output disable">
    ], "SWCLK pad control">,
    Register<"SWD", 0x80, 32, [
      Field<"SLEWFAST", 0, 1, ReadWrite, "Slew rate fast">,
      Field<"SCHMITT", 1, 1, ReadWrite, "Schmitt trigger enable">,
      Field<"PDE", 2, 1, ReadWrite, "Pull-down enable">,
      Field<"PUE", 3, 1, ReadWrite, "Pull-up enable">,
      Field<"DRIVE", 4, 2, ReadWrite, "Drive strength">,
      Field<"IE", 6, 1, ReadWrite, "Input enable">,
      Field<"OD", 7, 1, ReadWrite, "Output disable">
    ], "SWD pad control">
  ];
}

class PadsInstance<string Name, int Base> : PeripheralInstance<Name, Base, PadsPeripheral>;
def PADS_BANK0 : PadsInstance<"PADS_BANK0", 0x4001C000>;

#endif // _RP2040_PADS_TD
