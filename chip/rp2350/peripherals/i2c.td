// i2c.td - RP2040 I2C (DW_apb_i2c)

#ifndef _RP2040_I2C_TD
#define _RP2040_I2C_TD

include "base.td"

def I2CPeripheral : PeripheralType<"I2C", "I2C (DW_apb_i2c)"> {
  let accessWidth = 32;
  let registers = [
    Register<"CON", 0x00, 32, [
      Field<"MASTER_MODE", 0, 1, ReadWrite, "Master mode enable">,
      Field<"SPEED", 1, 2, ReadWrite, "Speed mode">,
      Field<"IC_10BITADDR_SLAVE", 3, 1, ReadWrite, "10-bit slave addressing">,
      Field<"IC_10BITADDR_MASTER", 4, 1, ReadWrite, "10-bit master addressing">,
      Field<"IC_RESTART_EN", 5, 1, ReadWrite, "Restart enable">,
      Field<"IC_SLAVE_DISABLE", 6, 1, ReadWrite, "Slave disable">,
      Field<"STOP_DET_IFADDRESSED", 7, 1, ReadWrite, "Stop detect if addressed">,
      Field<"TX_EMPTY_CTRL", 8, 1, ReadWrite, "TX empty control">,
      Field<"RX_FIFO_FULL_HLD_CTRL", 9, 1, ReadWrite, "RX FIFO full hold control">
    ], "Control register">,
    Register<"TAR", 0x04, 32, [
      Field<"TAR", 0, 10, ReadWrite, "Target address">,
      Field<"GC_OR_START", 10, 1, ReadWrite, "General call or start">,
      Field<"SPECIAL", 11, 1, ReadWrite, "Special command">
    ], "Target address">,
    Register<"SAR", 0x08, 32, [
      Field<"SAR", 0, 10, ReadWrite, "Slave address">
    ], "Slave address">,
    Register<"DATA_CMD", 0x10, 32, [
      Field<"DAT", 0, 8, ReadWrite, "Data">,
      Field<"CMD", 8, 1, Write, "Command (0=write, 1=read)">,
      Field<"STOP", 9, 1, Write, "Stop after byte">,
      Field<"RESTART", 10, 1, Write, "Restart before byte">,
      Field<"FIRST_DATA_BYTE", 11, 1, Read, "First data byte">
    ], "Data command">,
    Register<"SS_SCL_HCNT", 0x14, 32, [], "Standard speed SCL high count">,
    Register<"SS_SCL_LCNT", 0x18, 32, [], "Standard speed SCL low count">,
    Register<"FS_SCL_HCNT", 0x1C, 32, [], "Fast speed SCL high count">,
    Register<"FS_SCL_LCNT", 0x20, 32, [], "Fast speed SCL low count">,
    Register<"INTR_STAT", 0x2C, 32, [], "Interrupt status">,
    Register<"INTR_MASK", 0x30, 32, [], "Interrupt mask">,
    Register<"RAW_INTR_STAT", 0x34, 32, [], "Raw interrupt status">,
    Register<"RX_TL", 0x38, 32, [], "RX FIFO threshold">,
    Register<"TX_TL", 0x3C, 32, [], "TX FIFO threshold">,
    Register<"CLR_INTR", 0x40, 32, [], "Clear all interrupts">,
    Register<"CLR_RX_UNDER", 0x44, 32, [], "Clear RX underflow">,
    Register<"CLR_RX_OVER", 0x48, 32, [], "Clear RX overflow">,
    Register<"CLR_TX_OVER", 0x4C, 32, [], "Clear TX overflow">,
    Register<"CLR_RD_REQ", 0x50, 32, [], "Clear read request">,
    Register<"CLR_TX_ABRT", 0x54, 32, [], "Clear TX abort">,
    Register<"CLR_RX_DONE", 0x58, 32, [], "Clear RX done">,
    Register<"CLR_ACTIVITY", 0x5C, 32, [], "Clear activity">,
    Register<"CLR_STOP_DET", 0x60, 32, [], "Clear stop detect">,
    Register<"CLR_START_DET", 0x64, 32, [], "Clear start detect">,
    Register<"CLR_GEN_CALL", 0x68, 32, [], "Clear general call">,
    Register<"ENABLE", 0x6C, 32, [
      Field<"ENABLE", 0, 1, ReadWrite, "I2C enable">,
      Field<"ABORT", 1, 1, ReadWrite, "Abort transfer">,
      Field<"TX_CMD_BLOCK", 2, 1, ReadWrite, "TX command block">
    ], "Enable register">,
    Register<"STATUS", 0x70, 32, [
      Field<"ACTIVITY", 0, 1, Read, "I2C activity">,
      Field<"TFNF", 1, 1, Read, "TX FIFO not full">,
      Field<"TFE", 2, 1, Read, "TX FIFO empty">,
      Field<"RFNE", 3, 1, Read, "RX FIFO not empty">,
      Field<"RFF", 4, 1, Read, "RX FIFO full">,
      Field<"MST_ACTIVITY", 5, 1, Read, "Master activity">,
      Field<"SLV_ACTIVITY", 6, 1, Read, "Slave activity">
    ], "Status register">,
    Register<"TXFLR", 0x74, 32, [], "TX FIFO level">,
    Register<"RXFLR", 0x78, 32, [], "RX FIFO level">,
    Register<"SDA_HOLD", 0x7C, 32, [], "SDA hold time">,
    Register<"TX_ABRT_SOURCE", 0x80, 32, [], "TX abort source">,
    Register<"DMA_CR", 0x88, 32, [], "DMA control">,
    Register<"DMA_TDLR", 0x8C, 32, [], "DMA TX data level">,
    Register<"DMA_RDLR", 0x90, 32, [], "DMA RX data level">,
    Register<"SDA_SETUP", 0x94, 32, [], "SDA setup time">,
    Register<"ACK_GENERAL_CALL", 0x98, 32, [], "ACK general call">,
    Register<"ENABLE_STATUS", 0x9C, 32, [], "Enable status">,
    Register<"FS_SPKLEN", 0xA0, 32, [], "Fast speed spike suppression">,
    Register<"CLR_RESTART_DET", 0xA8, 32, [], "Clear restart detect">
  ];
}

class I2CInstance<string Name, int Base> : PeripheralInstance<Name, Base, I2CPeripheral>;
def I2C0 : I2CInstance<"I2C0", 0x40044000>;
def I2C1 : I2CInstance<"I2C1", 0x40048000>;

def I2Cs : PeripheralGroup<"I2Cs", [I2C0, I2C1]>;

#endif // _RP2040_I2C_TD
