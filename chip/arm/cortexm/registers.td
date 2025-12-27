// registers.td - ARM Cortex-M core register definitions
// Defines System Control Block (SCB) and other core peripheral registers

#ifndef _ARM_CORTEXM_REGISTERS_TD
#define _ARM_CORTEXM_REGISTERS_TD

include "base.td"

// System Control Block (SCB) - 0xE000ED00
def SCBPeripheral : PeripheralType<"SCB", "System Control Block"> {
  let accessWidth = 32;
  let registers = [
    Register<"CPUID", 0x00, 32, [], "CPUID Base Register">,
    Register<"ICSR", 0x04, 32, [
      Field<"VECTACTIVE", 0, 9, Read, "Active exception number">,
      Field<"RETTOBASE", 11, 1, Read, "Return to base">,
      Field<"VECTPENDING", 12, 9, Read, "Pending exception number">,
      Field<"ISRPENDING", 22, 1, Read, "Interrupt pending flag">,
      Field<"PENDSTCLR", 25, 1, Write, "Clear SysTick pending">,
      Field<"PENDSTSET", 26, 1, ReadWrite, "Set SysTick pending">,
      Field<"PENDSVCLR", 27, 1, Write, "Clear PendSV pending">,
      Field<"PENDSVSET", 28, 1, ReadWrite, "Set PendSV pending">,
      Field<"NMIPENDSET", 31, 1, ReadWrite, "Set NMI pending">
    ], "Interrupt Control and State Register">,
    Register<"VTOR", 0x08, 32, [
      Field<"TBLOFF", 7, 25, ReadWrite, "Vector table offset">
    ], "Vector Table Offset Register">,
    Register<"AIRCR", 0x0C, 32, [
      Field<"VECTRESET", 0, 1, Write, "System reset request">,
      Field<"VECTCLRACTIVE", 1, 1, Write, "Clear active exceptions">,
      Field<"SYSRESETREQ", 2, 1, Write, "System reset request">,
      Field<"PRIGROUP", 8, 3, ReadWrite, "Priority grouping">,
      Field<"ENDIANNESS", 15, 1, Read, "Data endianness">,
      Field<"VECTKEY", 16, 16, ReadWrite, "Register key">
    ], "Application Interrupt and Reset Control Register">,
    Register<"SCR", 0x10, 32, [
      Field<"SLEEPONEXIT", 1, 1, ReadWrite, "Sleep on exit">,
      Field<"SLEEPDEEP", 2, 1, ReadWrite, "Sleep deep">,
      Field<"SEVONPEND", 4, 1, ReadWrite, "Send event on pending">
    ], "System Control Register">,
    Register<"CCR", 0x14, 32, [
      Field<"NONBASETHRDENA", 0, 1, ReadWrite, "Non-base thread enable">,
      Field<"USERSETMPEND", 1, 1, ReadWrite, "User set pending">,
      Field<"UNALIGN_TRP", 3, 1, ReadWrite, "Unaligned trap">,
      Field<"DIV_0_TRP", 4, 1, ReadWrite, "Divide by zero trap">,
      Field<"BFHFNMIGN", 8, 1, ReadWrite, "Bus fault ignore">,
      Field<"STKALIGN", 9, 1, ReadWrite, "Stack alignment">
    ], "Configuration and Control Register">,
    Register<"SHPR1", 0x18, 32, [], "System Handler Priority Register 1">,
    Register<"SHPR2", 0x1C, 32, [], "System Handler Priority Register 2">,
    Register<"SHPR3", 0x20, 32, [], "System Handler Priority Register 3">,
    Register<"SHCSR", 0x24, 32, [
      Field<"MEMFAULTACT", 0, 1, ReadWrite, "MemManage active">,
      Field<"BUSFAULTACT", 1, 1, ReadWrite, "BusFault active">,
      Field<"USGFAULTACT", 3, 1, ReadWrite, "UsageFault active">,
      Field<"SVCALLACT", 7, 1, ReadWrite, "SVCall active">,
      Field<"MONITORACT", 8, 1, ReadWrite, "Monitor active">,
      Field<"PENDSVACT", 10, 1, ReadWrite, "PendSV active">,
      Field<"SYSTICKACT", 11, 1, ReadWrite, "SysTick active">,
      Field<"USGFAULTPENDED", 12, 1, ReadWrite, "UsageFault pending">,
      Field<"MEMFAULTPENDED", 13, 1, ReadWrite, "MemManage pending">,
      Field<"BUSFAULTPENDED", 14, 1, ReadWrite, "BusFault pending">,
      Field<"SVCALLPENDED", 15, 1, ReadWrite, "SVCall pending">,
      Field<"MEMFAULTENA", 16, 1, ReadWrite, "MemManage enable">,
      Field<"BUSFAULTENA", 17, 1, ReadWrite, "BusFault enable">,
      Field<"USGFAULTENA", 18, 1, ReadWrite, "UsageFault enable">
    ], "System Handler Control and State Register">
  ];
}

class SCBInstance<string Name, int Base> : PeripheralInstance<Name, Base, SCBPeripheral>;
def SCB : SCBInstance<"SCB", 0xE000ED00>;

// SysTick Timer - 0xE000E010
def SysTickPeripheral : PeripheralType<"SysTick", "System Timer"> {
  let accessWidth = 32;
  let registers = [
    Register<"CTRL", 0x00, 32, [
      Field<"ENABLE", 0, 1, ReadWrite, "Counter enable">,
      Field<"TICKINT", 1, 1, ReadWrite, "Interrupt enable">,
      Field<"CLKSOURCE", 2, 1, ReadWrite, "Clock source">,
      Field<"COUNTFLAG", 16, 1, Read, "Count flag">
    ], "SysTick Control and Status Register">,
    Register<"LOAD", 0x04, 32, [
      Field<"RELOAD", 0, 24, ReadWrite, "Reload value">
    ], "SysTick Reload Value Register">,
    Register<"VAL", 0x08, 32, [
      Field<"CURRENT", 0, 24, ReadWrite, "Current value">
    ], "SysTick Current Value Register">,
    Register<"CALIB", 0x0C, 32, [
      Field<"TENMS", 0, 24, Read, "Calibration value">,
      Field<"SKEW", 30, 1, Read, "Skew flag">,
      Field<"NOREF", 31, 1, Read, "No reference clock">
    ], "SysTick Calibration Value Register">
  ];
}

class SysTickInstance<string Name, int Base> : PeripheralInstance<Name, Base, SysTickPeripheral>;
def SysTick : SysTickInstance<"SysTick", 0xE000E010>;

// NVIC - Nested Vectored Interrupt Controller - 0xE000E100
def NVICPeripheral : PeripheralType<"NVIC", "Nested Vectored Interrupt Controller"> {
  let accessWidth = 32;
  let registers = [
    RepeatingRegister<"ISER", 8, 0x000, 32, [], "Interrupt Set Enable Registers">,
    RepeatingRegister<"ICER", 8, 0x080, 32, [], "Interrupt Clear Enable Registers">,
    RepeatingRegister<"ISPR", 8, 0x100, 32, [], "Interrupt Set Pending Registers">,
    RepeatingRegister<"ICPR", 8, 0x180, 32, [], "Interrupt Clear Pending Registers">,
    RepeatingRegister<"IABR", 8, 0x200, 32, [], "Interrupt Active Bit Registers">,
    RepeatingRegister<"IPR", 60, 0x300, 32, [], "Interrupt Priority Registers">
  ];
}

class NVICInstance<string Name, int Base> : PeripheralInstance<Name, Base, NVICPeripheral>;
def NVIC : NVICInstance<"NVIC", 0xE000E100>;

#endif // _ARM_CORTEXM_REGISTERS_TD
