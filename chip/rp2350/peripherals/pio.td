// pio.td - RP2040 Programmable I/O

#ifndef _RP2040_PIO_TD
#define _RP2040_PIO_TD

include "base.td"

def PIOPeripheral : PeripheralType<"PIO", "Programmable I/O"> {
  let accessWidth = 32;
  let registers = [
    Register<"CTRL", 0x00, 32, [
      Field<"SM_ENABLE", 0, 4, ReadWrite, "State machine enable">,
      Field<"SM_RESTART", 4, 4, Write, "State machine restart">,
      Field<"CLKDIV_RESTART", 8, 4, Write, "Clock divider restart">
    ], "PIO control">,
    Register<"FSTAT", 0x04, 32, [
      Field<"RXFULL", 0, 4, Read, "RX FIFO full">,
      Field<"RXEMPTY", 8, 4, Read, "RX FIFO empty">,
      Field<"TXFULL", 16, 4, Read, "TX FIFO full">,
      Field<"TXEMPTY", 24, 4, Read, "TX FIFO empty">
    ], "FIFO status">,
    Register<"FDEBUG", 0x08, 32, [
      Field<"RXSTALL", 0, 4, ReadWrite, "RX stall">,
      Field<"RXUNDER", 8, 4, ReadWrite, "RX underflow">,
      Field<"TXOVER", 16, 4, ReadWrite, "TX overflow">,
      Field<"TXSTALL", 24, 4, ReadWrite, "TX stall">
    ], "FIFO debug">,
    Register<"FLEVEL", 0x0C, 32, [
      Field<"TX0", 0, 4, Read, "TX FIFO 0 level">,
      Field<"RX0", 4, 4, Read, "RX FIFO 0 level">,
      Field<"TX1", 8, 4, Read, "TX FIFO 1 level">,
      Field<"RX1", 12, 4, Read, "RX FIFO 1 level">,
      Field<"TX2", 16, 4, Read, "TX FIFO 2 level">,
      Field<"RX2", 20, 4, Read, "RX FIFO 2 level">,
      Field<"TX3", 24, 4, Read, "TX FIFO 3 level">,
      Field<"RX3", 28, 4, Read, "RX FIFO 3 level">
    ], "FIFO levels">,
    Register<"TXF0", 0x10, 32, [], "TX FIFO 0">,
    Register<"TXF1", 0x14, 32, [], "TX FIFO 1">,
    Register<"TXF2", 0x18, 32, [], "TX FIFO 2">,
    Register<"TXF3", 0x1C, 32, [], "TX FIFO 3">,
    Register<"RXF0", 0x20, 32, [], "RX FIFO 0">,
    Register<"RXF1", 0x24, 32, [], "RX FIFO 1">,
    Register<"RXF2", 0x28, 32, [], "RX FIFO 2">,
    Register<"RXF3", 0x2C, 32, [], "RX FIFO 3">,
    Register<"IRQ", 0x30, 32, [], "IRQ flags">,
    Register<"IRQ_FORCE", 0x34, 32, [], "IRQ force">,
    Register<"INPUT_SYNC_BYPASS", 0x38, 32, [], "Input sync bypass">,
    Register<"DBG_PADOUT", 0x3C, 32, [], "Debug pad output">,
    Register<"DBG_PADOE", 0x40, 32, [], "Debug pad output enable">,
    Register<"DBG_CFGINFO", 0x44, 32, [], "Debug config info">,
    RepeatingRegister<"INSTR_MEM", 32, 0x48, 32, [], "Instruction memory">,
    // State machine 0 registers
    Register<"SM0_CLKDIV", 0xC8, 32, [
      Field<"FRAC", 8, 8, ReadWrite, "Fractional divider">,
      Field<"INT", 16, 16, ReadWrite, "Integer divider">
    ], "SM0 clock divider">,
    Register<"SM0_EXECCTRL", 0xCC, 32, [
      Field<"STATUS_N", 0, 4, ReadWrite, "Status N">,
      Field<"STATUS_SEL", 4, 1, ReadWrite, "Status select">,
      Field<"WRAP_BOTTOM", 7, 5, ReadWrite, "Wrap bottom">,
      Field<"WRAP_TOP", 12, 5, ReadWrite, "Wrap top">,
      Field<"OUT_STICKY", 17, 1, ReadWrite, "Out sticky">,
      Field<"INLINE_OUT_EN", 18, 1, ReadWrite, "Inline out enable">,
      Field<"OUT_EN_SEL", 19, 5, ReadWrite, "Out enable select">,
      Field<"JMP_PIN", 24, 5, ReadWrite, "Jump pin">,
      Field<"SIDE_PINDIR", 29, 1, ReadWrite, "Side-set pin direction">,
      Field<"SIDE_EN", 30, 1, ReadWrite, "Side-set enable">,
      Field<"EXEC_STALLED", 31, 1, Read, "Execution stalled">
    ], "SM0 execution control">,
    Register<"SM0_SHIFTCTRL", 0xD0, 32, [
      Field<"AUTOPUSH", 16, 1, ReadWrite, "Auto push">,
      Field<"AUTOPULL", 17, 1, ReadWrite, "Auto pull">,
      Field<"IN_SHIFTDIR", 18, 1, ReadWrite, "In shift direction">,
      Field<"OUT_SHIFTDIR", 19, 1, ReadWrite, "Out shift direction">,
      Field<"PUSH_THRESH", 20, 5, ReadWrite, "Push threshold">,
      Field<"PULL_THRESH", 25, 5, ReadWrite, "Pull threshold">,
      Field<"FJOIN_TX", 30, 1, ReadWrite, "Join TX FIFO">,
      Field<"FJOIN_RX", 31, 1, ReadWrite, "Join RX FIFO">
    ], "SM0 shift control">,
    Register<"SM0_ADDR", 0xD4, 32, [], "SM0 current address">,
    Register<"SM0_INSTR", 0xD8, 32, [], "SM0 current instruction">,
    Register<"SM0_PINCTRL", 0xDC, 32, [
      Field<"OUT_BASE", 0, 5, ReadWrite, "Out base pin">,
      Field<"SET_BASE", 5, 5, ReadWrite, "Set base pin">,
      Field<"SIDESET_BASE", 10, 5, ReadWrite, "Side-set base pin">,
      Field<"IN_BASE", 15, 5, ReadWrite, "In base pin">,
      Field<"OUT_COUNT", 20, 6, ReadWrite, "Out count">,
      Field<"SET_COUNT", 26, 3, ReadWrite, "Set count">,
      Field<"SIDESET_COUNT", 29, 3, ReadWrite, "Side-set count">
    ], "SM0 pin control">,
    // State machines 1-3 have similar registers at offsets +0x18, +0x30, +0x48
    Register<"SM1_CLKDIV", 0xE0, 32, [], "SM1 clock divider">,
    Register<"SM1_EXECCTRL", 0xE4, 32, [], "SM1 execution control">,
    Register<"SM1_SHIFTCTRL", 0xE8, 32, [], "SM1 shift control">,
    Register<"SM1_ADDR", 0xEC, 32, [], "SM1 current address">,
    Register<"SM1_INSTR", 0xF0, 32, [], "SM1 current instruction">,
    Register<"SM1_PINCTRL", 0xF4, 32, [], "SM1 pin control">,
    Register<"SM2_CLKDIV", 0xF8, 32, [], "SM2 clock divider">,
    Register<"SM2_EXECCTRL", 0xFC, 32, [], "SM2 execution control">,
    Register<"SM2_SHIFTCTRL", 0x100, 32, [], "SM2 shift control">,
    Register<"SM2_ADDR", 0x104, 32, [], "SM2 current address">,
    Register<"SM2_INSTR", 0x108, 32, [], "SM2 current instruction">,
    Register<"SM2_PINCTRL", 0x10C, 32, [], "SM2 pin control">,
    Register<"SM3_CLKDIV", 0x110, 32, [], "SM3 clock divider">,
    Register<"SM3_EXECCTRL", 0x114, 32, [], "SM3 execution control">,
    Register<"SM3_SHIFTCTRL", 0x118, 32, [], "SM3 shift control">,
    Register<"SM3_ADDR", 0x11C, 32, [], "SM3 current address">,
    Register<"SM3_INSTR", 0x120, 32, [], "SM3 current instruction">,
    Register<"SM3_PINCTRL", 0x124, 32, [], "SM3 pin control">,
    Register<"INTR", 0x128, 32, [], "Raw interrupts">,
    Register<"IRQ0_INTE", 0x12C, 32, [], "IRQ0 interrupt enable">,
    Register<"IRQ0_INTF", 0x130, 32, [], "IRQ0 interrupt force">,
    Register<"IRQ0_INTS", 0x134, 32, [], "IRQ0 interrupt status">,
    Register<"IRQ1_INTE", 0x138, 32, [], "IRQ1 interrupt enable">,
    Register<"IRQ1_INTF", 0x13C, 32, [], "IRQ1 interrupt force">,
    Register<"IRQ1_INTS", 0x140, 32, [], "IRQ1 interrupt status">
  ];
}

class PIOInstance<string Name, int Base> : PeripheralInstance<Name, Base, PIOPeripheral>;
def PIO0 : PIOInstance<"PIO0", 0x50200000>;
def PIO1 : PIOInstance<"PIO1", 0x50300000>;

def PIOs : PeripheralGroup<"PIOs", [PIO0, PIO1]>;

#endif // _RP2040_PIO_TD
