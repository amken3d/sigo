// watchdog.td - RP2040 Watchdog Timer

#ifndef _RP2040_WATCHDOG_TD
#define _RP2040_WATCHDOG_TD

include "base.td"

def WatchdogPeripheral : PeripheralType<"WATCHDOG", "Watchdog Timer"> {
  let accessWidth = 32;
  let registers = [
    Register<"CTRL", 0x00, 32, [
      Field<"TIME", 0, 24, Read, "Time remaining">,
      Field<"PAUSE_JTAG", 24, 1, ReadWrite, "Pause when JTAG">,
      Field<"PAUSE_DBG0", 25, 1, ReadWrite, "Pause when debug 0">,
      Field<"PAUSE_DBG1", 26, 1, ReadWrite, "Pause when debug 1">,
      Field<"ENABLE", 30, 1, ReadWrite, "Enable">,
      Field<"TRIGGER", 31, 1, Write, "Trigger reset">
    ], "Control">,
    Register<"LOAD", 0x04, 32, [
      Field<"LOAD", 0, 24, Write, "Load value">
    ], "Load">,
    Register<"REASON", 0x08, 32, [
      Field<"TIMER", 0, 1, Read, "Timer reset">,
      Field<"FORCE", 1, 1, Read, "Force reset">
    ], "Reset reason">,
    Register<"SCRATCH0", 0x0C, 32, [], "Scratch 0">,
    Register<"SCRATCH1", 0x10, 32, [], "Scratch 1">,
    Register<"SCRATCH2", 0x14, 32, [], "Scratch 2">,
    Register<"SCRATCH3", 0x18, 32, [], "Scratch 3">,
    Register<"SCRATCH4", 0x1C, 32, [], "Scratch 4">,
    Register<"SCRATCH5", 0x20, 32, [], "Scratch 5">,
    Register<"SCRATCH6", 0x24, 32, [], "Scratch 6">,
    Register<"SCRATCH7", 0x28, 32, [], "Scratch 7">,
    Register<"TICK", 0x2C, 32, [
      Field<"CYCLES", 0, 9, ReadWrite, "Tick cycles">,
      Field<"ENABLE", 9, 1, ReadWrite, "Tick enable">,
      Field<"RUNNING", 10, 1, Read, "Tick running">,
      Field<"COUNT", 11, 9, Read, "Tick count">
    ], "Tick">
  ];
}

class WatchdogInstance<string Name, int Base> : PeripheralInstance<Name, Base, WatchdogPeripheral>;
def WATCHDOG : WatchdogInstance<"WATCHDOG", 0x40058000>;

#endif // _RP2040_WATCHDOG_TD
