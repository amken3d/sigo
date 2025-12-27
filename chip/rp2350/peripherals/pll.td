// pll.td - RP2040 Phase-Locked Loop

#ifndef _RP2040_PLL_TD
#define _RP2040_PLL_TD

include "base.td"

def PLLPeripheral : PeripheralType<"PLL", "Phase-Locked Loop"> {
  let accessWidth = 32;
  let registers = [
    Register<"CS", 0x00, 32, [
      Field<"REFDIV", 0, 6, ReadWrite, "Reference divider">,
      Field<"BYPASS", 8, 1, ReadWrite, "Bypass">,
      Field<"LOCK", 31, 1, Read, "PLL locked">
    ], "Control and status">,
    Register<"PWR", 0x04, 32, [
      Field<"PD", 0, 1, ReadWrite, "Power down">,
      Field<"DSMPD", 2, 1, ReadWrite, "DSM power down">,
      Field<"POSTDIVPD", 3, 1, ReadWrite, "Post divider power down">,
      Field<"VCOPD", 5, 1, ReadWrite, "VCO power down">
    ], "Power control">,
    Register<"FBDIV_INT", 0x08, 32, [
      Field<"FBDIV_INT", 0, 12, ReadWrite, "Feedback divider">
    ], "Feedback divider">,
    Register<"PRIM", 0x0C, 32, [
      Field<"POSTDIV2", 12, 3, ReadWrite, "Post divider 2">,
      Field<"POSTDIV1", 16, 3, ReadWrite, "Post divider 1">
    ], "Post dividers">
  ];
}

class PLLInstance<string Name, int Base> : PeripheralInstance<Name, Base, PLLPeripheral>;
def PLL_SYS : PLLInstance<"PLL_SYS", 0x40028000>;
def PLL_USB : PLLInstance<"PLL_USB", 0x4002C000>;

def PLLs : PeripheralGroup<"PLLs", [PLL_SYS, PLL_USB]>;

#endif // _RP2040_PLL_TD
