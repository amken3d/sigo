// pwm.td - RP2040 PWM

#ifndef _RP2040_PWM_TD
#define _RP2040_PWM_TD

include "base.td"

def PWMPeripheral : PeripheralType<"PWM", "Pulse Width Modulation"> {
  let accessWidth = 32;
  let count = 8;  // 8 PWM slices
  let arrayLabel = "CH";
  let registers = [
    Register<"CSR", 0x00, 32, [
      Field<"EN", 0, 1, ReadWrite, "Enable">,
      Field<"PH_CORRECT", 1, 1, ReadWrite, "Phase correct">,
      Field<"A_INV", 2, 1, ReadWrite, "Invert A">,
      Field<"B_INV", 3, 1, ReadWrite, "Invert B">,
      Field<"DIVMODE", 4, 2, ReadWrite, "Divider mode">,
      Field<"PH_RET", 6, 1, ReadWrite, "Phase retard">,
      Field<"PH_ADV", 7, 1, ReadWrite, "Phase advance">
    ], "Control and status">,
    Register<"DIV", 0x04, 32, [
      Field<"FRAC", 0, 4, ReadWrite, "Fractional divider">,
      Field<"INT", 4, 8, ReadWrite, "Integer divider">
    ], "Clock divider">,
    Register<"CTR", 0x08, 32, [
      Field<"CTR", 0, 16, ReadWrite, "Counter">
    ], "Counter">,
    Register<"CC", 0x0C, 32, [
      Field<"A", 0, 16, ReadWrite, "Channel A compare">,
      Field<"B", 16, 16, ReadWrite, "Channel B compare">
    ], "Compare values">,
    Register<"TOP", 0x10, 32, [
      Field<"TOP", 0, 16, ReadWrite, "Counter wrap value">
    ], "Counter wrap value">
  ];
}

class PWMInstance<string Name, int Base> : PeripheralInstance<Name, Base, PWMPeripheral>;
def PWM : PWMInstance<"PWM", 0x40050000>;

// PWM interrupt and enable registers
def PWMINTRPeripheral : PeripheralType<"PWM_INTR", "PWM Interrupt Control"> {
  let accessWidth = 32;
  let registers = [
    Register<"EN", 0x00, 32, [], "Enable">,
    Register<"INTR", 0x04, 32, [], "Raw interrupts">,
    Register<"INTE", 0x08, 32, [], "Interrupt enable">,
    Register<"INTF", 0x0C, 32, [], "Interrupt force">,
    Register<"INTS", 0x10, 32, [], "Interrupt status">
  ];
}

class PWMINTRInstance<string Name, int Base> : PeripheralInstance<Name, Base, PWMINTRPeripheral>;
def PWM_INTR : PWMINTRInstance<"PWM_INTR", 0x400500A0>;

#endif // _RP2040_PWM_TD
