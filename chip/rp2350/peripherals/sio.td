// sio.td - RP2040 Single-cycle I/O

#ifndef _RP2040_SIO_TD
#define _RP2040_SIO_TD

include "base.td"

def SIOPeripheral : PeripheralType<"SIO", "Single-cycle I/O"> {
  let accessWidth = 32;
  let registers = [
    Register<"CPUID", 0x00, 32, [], "Processor core identifier">,
    Register<"GPIO_IN", 0x04, 32, [], "GPIO input values">,
    Register<"GPIO_HI_IN", 0x08, 32, [], "QSPI GPIO input values">,
    Register<"GPIO_OUT", 0x10, 32, [], "GPIO output values">,
    Register<"GPIO_OUT_SET", 0x14, 32, [], "GPIO output set">,
    Register<"GPIO_OUT_CLR", 0x18, 32, [], "GPIO output clear">,
    Register<"GPIO_OUT_XOR", 0x1C, 32, [], "GPIO output XOR">,
    Register<"GPIO_OE", 0x20, 32, [], "GPIO output enable">,
    Register<"GPIO_OE_SET", 0x24, 32, [], "GPIO output enable set">,
    Register<"GPIO_OE_CLR", 0x28, 32, [], "GPIO output enable clear">,
    Register<"GPIO_OE_XOR", 0x2C, 32, [], "GPIO output enable XOR">,
    Register<"GPIO_HI_OUT", 0x30, 32, [], "QSPI GPIO output values">,
    Register<"GPIO_HI_OUT_SET", 0x34, 32, [], "QSPI GPIO output set">,
    Register<"GPIO_HI_OUT_CLR", 0x38, 32, [], "QSPI GPIO output clear">,
    Register<"GPIO_HI_OUT_XOR", 0x3C, 32, [], "QSPI GPIO output XOR">,
    Register<"GPIO_HI_OE", 0x40, 32, [], "QSPI GPIO output enable">,
    Register<"GPIO_HI_OE_SET", 0x44, 32, [], "QSPI GPIO output enable set">,
    Register<"GPIO_HI_OE_CLR", 0x48, 32, [], "QSPI GPIO output enable clear">,
    Register<"GPIO_HI_OE_XOR", 0x4C, 32, [], "QSPI GPIO output enable XOR">,
    Register<"FIFO_ST", 0x50, 32, [
      Field<"VLD", 0, 1, Read, "FIFO valid">,
      Field<"RDY", 1, 1, Read, "FIFO ready">,
      Field<"WOF", 2, 1, ReadWrite, "Write overflow">,
      Field<"ROE", 3, 1, ReadWrite, "Read underflow">
    ], "Inter-core FIFO status">,
    Register<"FIFO_WR", 0x54, 32, [], "Inter-core FIFO write">,
    Register<"FIFO_RD", 0x58, 32, [], "Inter-core FIFO read">,
    Register<"SPINLOCK_ST", 0x5C, 32, [], "Spinlock state">,
    Register<"DIV_UDIVIDEND", 0x60, 32, [], "Unsigned dividend">,
    Register<"DIV_UDIVISOR", 0x64, 32, [], "Unsigned divisor">,
    Register<"DIV_SDIVIDEND", 0x68, 32, [], "Signed dividend">,
    Register<"DIV_SDIVISOR", 0x6C, 32, [], "Signed divisor">,
    Register<"DIV_QUOTIENT", 0x70, 32, [], "Division quotient">,
    Register<"DIV_REMAINDER", 0x74, 32, [], "Division remainder">,
    Register<"DIV_CSR", 0x78, 32, [
      Field<"READY", 0, 1, Read, "Divider ready">,
      Field<"DIRTY", 1, 1, Read, "Divider dirty">
    ], "Divider control and status">,
    Register<"INTERP0_ACCUM0", 0x80, 32, [], "Interpolator 0 accumulator 0">,
    Register<"INTERP0_ACCUM1", 0x84, 32, [], "Interpolator 0 accumulator 1">,
    Register<"INTERP0_BASE0", 0x88, 32, [], "Interpolator 0 base 0">,
    Register<"INTERP0_BASE1", 0x8C, 32, [], "Interpolator 0 base 1">,
    Register<"INTERP0_BASE2", 0x90, 32, [], "Interpolator 0 base 2">,
    Register<"INTERP0_POP_LANE0", 0x94, 32, [], "Interpolator 0 pop lane 0">,
    Register<"INTERP0_POP_LANE1", 0x98, 32, [], "Interpolator 0 pop lane 1">,
    Register<"INTERP0_POP_FULL", 0x9C, 32, [], "Interpolator 0 pop full">,
    Register<"INTERP0_PEEK_LANE0", 0xA0, 32, [], "Interpolator 0 peek lane 0">,
    Register<"INTERP0_PEEK_LANE1", 0xA4, 32, [], "Interpolator 0 peek lane 1">,
    Register<"INTERP0_PEEK_FULL", 0xA8, 32, [], "Interpolator 0 peek full">,
    Register<"INTERP0_CTRL_LANE0", 0xAC, 32, [], "Interpolator 0 control lane 0">,
    Register<"INTERP0_CTRL_LANE1", 0xB0, 32, [], "Interpolator 0 control lane 1">,
    Register<"INTERP0_ACCUM0_ADD", 0xB4, 32, [], "Interpolator 0 accumulator 0 add">,
    Register<"INTERP0_ACCUM1_ADD", 0xB8, 32, [], "Interpolator 0 accumulator 1 add">,
    Register<"INTERP0_BASE_1AND0", 0xBC, 32, [], "Interpolator 0 base 1 and 0">,
    Register<"INTERP1_ACCUM0", 0xC0, 32, [], "Interpolator 1 accumulator 0">,
    Register<"INTERP1_ACCUM1", 0xC4, 32, [], "Interpolator 1 accumulator 1">,
    Register<"INTERP1_BASE0", 0xC8, 32, [], "Interpolator 1 base 0">,
    Register<"INTERP1_BASE1", 0xCC, 32, [], "Interpolator 1 base 1">,
    Register<"INTERP1_BASE2", 0xD0, 32, [], "Interpolator 1 base 2">,
    Register<"INTERP1_POP_LANE0", 0xD4, 32, [], "Interpolator 1 pop lane 0">,
    Register<"INTERP1_POP_LANE1", 0xD8, 32, [], "Interpolator 1 pop lane 1">,
    Register<"INTERP1_POP_FULL", 0xDC, 32, [], "Interpolator 1 pop full">,
    Register<"INTERP1_PEEK_LANE0", 0xE0, 32, [], "Interpolator 1 peek lane 0">,
    Register<"INTERP1_PEEK_LANE1", 0xE4, 32, [], "Interpolator 1 peek lane 1">,
    Register<"INTERP1_PEEK_FULL", 0xE8, 32, [], "Interpolator 1 peek full">,
    Register<"INTERP1_CTRL_LANE0", 0xEC, 32, [], "Interpolator 1 control lane 0">,
    Register<"INTERP1_CTRL_LANE1", 0xF0, 32, [], "Interpolator 1 control lane 1">,
    Register<"INTERP1_ACCUM0_ADD", 0xF4, 32, [], "Interpolator 1 accumulator 0 add">,
    Register<"INTERP1_ACCUM1_ADD", 0xF8, 32, [], "Interpolator 1 accumulator 1 add">,
    Register<"INTERP1_BASE_1AND0", 0xFC, 32, [], "Interpolator 1 base 1 and 0">,
    RepeatingRegister<"SPINLOCK", 32, 0x100, 32, [], "Hardware spinlocks">
  ];
}

class SIOInstance<string Name, int Base> : PeripheralInstance<Name, Base, SIOPeripheral>;
def SIO : SIOInstance<"SIO", 0xD0000000>;

#endif // _RP2040_SIO_TD
