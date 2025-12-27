// timer.td - RP2040 Timer

#ifndef _RP2040_TIMER_TD
#define _RP2040_TIMER_TD

include "base.td"

def TimerPeripheral : PeripheralType<"TIMER", "64-bit Timer"> {
  let accessWidth = 32;
  let registers = [
    Register<"TIMEHW", 0x00, 32, [], "Write high bits of time">,
    Register<"TIMELW", 0x04, 32, [], "Write low bits of time">,
    Register<"TIMEHR", 0x08, 32, [], "Read high bits of time">,
    Register<"TIMELR", 0x0C, 32, [], "Read low bits of time">,
    Register<"ALARM0", 0x10, 32, [], "Alarm 0 time">,
    Register<"ALARM1", 0x14, 32, [], "Alarm 1 time">,
    Register<"ALARM2", 0x18, 32, [], "Alarm 2 time">,
    Register<"ALARM3", 0x1C, 32, [], "Alarm 3 time">,
    Register<"ARMED", 0x20, 32, [
      Field<"ALARM0", 0, 1, ReadWrite, "Alarm 0 armed">,
      Field<"ALARM1", 1, 1, ReadWrite, "Alarm 1 armed">,
      Field<"ALARM2", 2, 1, ReadWrite, "Alarm 2 armed">,
      Field<"ALARM3", 3, 1, ReadWrite, "Alarm 3 armed">
    ], "Armed alarms">,
    Register<"TIMERAWH", 0x24, 32, [], "Raw high bits of time (no latching)">,
    Register<"TIMERAWL", 0x28, 32, [], "Raw low bits of time (no latching)">,
    Register<"DBGPAUSE", 0x2C, 32, [
      Field<"DBG0", 1, 1, ReadWrite, "Pause when processor 0 is in debug mode">,
      Field<"DBG1", 2, 1, ReadWrite, "Pause when processor 1 is in debug mode">
    ], "Debug pause control">,
    Register<"PAUSE", 0x30, 32, [
      Field<"PAUSE", 0, 1, ReadWrite, "Pause timer">
    ], "Pause control">,
    Register<"INTR", 0x34, 32, [
      Field<"ALARM0", 0, 1, ReadWrite, "Alarm 0 interrupt">,
      Field<"ALARM1", 1, 1, ReadWrite, "Alarm 1 interrupt">,
      Field<"ALARM2", 2, 1, ReadWrite, "Alarm 2 interrupt">,
      Field<"ALARM3", 3, 1, ReadWrite, "Alarm 3 interrupt">
    ], "Raw interrupts">,
    Register<"INTE", 0x38, 32, [
      Field<"ALARM0", 0, 1, ReadWrite, "Alarm 0 interrupt enable">,
      Field<"ALARM1", 1, 1, ReadWrite, "Alarm 1 interrupt enable">,
      Field<"ALARM2", 2, 1, ReadWrite, "Alarm 2 interrupt enable">,
      Field<"ALARM3", 3, 1, ReadWrite, "Alarm 3 interrupt enable">
    ], "Interrupt enable">,
    Register<"INTF", 0x3C, 32, [], "Interrupt force">,
    Register<"INTS", 0x40, 32, [], "Interrupt status">
  ];
}

class TimerInstance<string Name, int Base> : PeripheralInstance<Name, Base, TimerPeripheral>;
def TIMER : TimerInstance<"TIMER", 0x40054000>;

#endif // _RP2040_TIMER_TD
