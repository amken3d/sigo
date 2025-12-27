// uart.td - RP2040 UART (PL011)

#ifndef _RP2040_UART_TD
#define _RP2040_UART_TD

include "base.td"

def UARTPeripheral : PeripheralType<"UART", "UART (PL011)"> {
  let accessWidth = 32;
  let registers = [
    Register<"DR", 0x00, 32, [
      Field<"DATA", 0, 8, ReadWrite, "Data">,
      Field<"FE", 8, 1, Read, "Framing error">,
      Field<"PE", 9, 1, Read, "Parity error">,
      Field<"BE", 10, 1, Read, "Break error">,
      Field<"OE", 11, 1, Read, "Overrun error">
    ], "Data register">,
    Register<"RSR", 0x04, 32, [
      Field<"FE", 0, 1, ReadWrite, "Framing error">,
      Field<"PE", 1, 1, ReadWrite, "Parity error">,
      Field<"BE", 2, 1, ReadWrite, "Break error">,
      Field<"OE", 3, 1, ReadWrite, "Overrun error">
    ], "Receive status/error clear">,
    Register<"FR", 0x18, 32, [
      Field<"CTS", 0, 1, Read, "Clear to send">,
      Field<"DSR", 1, 1, Read, "Data set ready">,
      Field<"DCD", 2, 1, Read, "Data carrier detect">,
      Field<"BUSY", 3, 1, Read, "UART busy">,
      Field<"RXFE", 4, 1, Read, "Receive FIFO empty">,
      Field<"TXFF", 5, 1, Read, "Transmit FIFO full">,
      Field<"RXFF", 6, 1, Read, "Receive FIFO full">,
      Field<"TXFE", 7, 1, Read, "Transmit FIFO empty">,
      Field<"RI", 8, 1, Read, "Ring indicator">
    ], "Flag register">,
    Register<"ILPR", 0x20, 32, [], "IrDA low-power counter">,
    Register<"IBRD", 0x24, 32, [
      Field<"BAUD_DIVINT", 0, 16, ReadWrite, "Integer baud rate divisor">
    ], "Integer baud rate">,
    Register<"FBRD", 0x28, 32, [
      Field<"BAUD_DIVFRAC", 0, 6, ReadWrite, "Fractional baud rate divisor">
    ], "Fractional baud rate">,
    Register<"LCR_H", 0x2C, 32, [
      Field<"BRK", 0, 1, ReadWrite, "Send break">,
      Field<"PEN", 1, 1, ReadWrite, "Parity enable">,
      Field<"EPS", 2, 1, ReadWrite, "Even parity select">,
      Field<"STP2", 3, 1, ReadWrite, "Two stop bits">,
      Field<"FEN", 4, 1, ReadWrite, "FIFO enable">,
      Field<"WLEN", 5, 2, ReadWrite, "Word length", [
        Enum<"BITS_5", 0, "5 bits">,
        Enum<"BITS_6", 1, "6 bits">,
        Enum<"BITS_7", 2, "7 bits">,
        Enum<"BITS_8", 3, "8 bits">
      ]>,
      Field<"SPS", 7, 1, ReadWrite, "Stick parity select">
    ], "Line control">,
    Register<"CR", 0x30, 32, [
      Field<"UARTEN", 0, 1, ReadWrite, "UART enable">,
      Field<"SIREN", 1, 1, ReadWrite, "SIR enable">,
      Field<"SIRLP", 2, 1, ReadWrite, "SIR low-power mode">,
      Field<"LBE", 7, 1, ReadWrite, "Loopback enable">,
      Field<"TXE", 8, 1, ReadWrite, "Transmit enable">,
      Field<"RXE", 9, 1, ReadWrite, "Receive enable">,
      Field<"DTR", 10, 1, ReadWrite, "Data transmit ready">,
      Field<"RTS", 11, 1, ReadWrite, "Request to send">,
      Field<"OUT1", 12, 1, ReadWrite, "Out1">,
      Field<"OUT2", 13, 1, ReadWrite, "Out2">,
      Field<"RTSEN", 14, 1, ReadWrite, "RTS hardware flow control">,
      Field<"CTSEN", 15, 1, ReadWrite, "CTS hardware flow control">
    ], "Control register">,
    Register<"IFLS", 0x34, 32, [
      Field<"TXIFLSEL", 0, 3, ReadWrite, "TX FIFO level select">,
      Field<"RXIFLSEL", 3, 3, ReadWrite, "RX FIFO level select">
    ], "Interrupt FIFO level select">,
    Register<"IMSC", 0x38, 32, [
      Field<"RIMIM", 0, 1, ReadWrite, "RI modem interrupt mask">,
      Field<"CTSMIM", 1, 1, ReadWrite, "CTS modem interrupt mask">,
      Field<"DCDMIM", 2, 1, ReadWrite, "DCD modem interrupt mask">,
      Field<"DSRMIM", 3, 1, ReadWrite, "DSR modem interrupt mask">,
      Field<"RXIM", 4, 1, ReadWrite, "RX interrupt mask">,
      Field<"TXIM", 5, 1, ReadWrite, "TX interrupt mask">,
      Field<"RTIM", 6, 1, ReadWrite, "RT interrupt mask">,
      Field<"FEIM", 7, 1, ReadWrite, "FE interrupt mask">,
      Field<"PEIM", 8, 1, ReadWrite, "PE interrupt mask">,
      Field<"BEIM", 9, 1, ReadWrite, "BE interrupt mask">,
      Field<"OEIM", 10, 1, ReadWrite, "OE interrupt mask">
    ], "Interrupt mask">,
    Register<"RIS", 0x3C, 32, [], "Raw interrupt status">,
    Register<"MIS", 0x40, 32, [], "Masked interrupt status">,
    Register<"ICR", 0x44, 32, [], "Interrupt clear">,
    Register<"DMACR", 0x48, 32, [
      Field<"RXDMAE", 0, 1, ReadWrite, "RX DMA enable">,
      Field<"TXDMAE", 1, 1, ReadWrite, "TX DMA enable">,
      Field<"DMAONERR", 2, 1, ReadWrite, "DMA on error">
    ], "DMA control">
  ];
}

class UARTInstance<string Name, int Base> : PeripheralInstance<Name, Base, UARTPeripheral>;
def UART0 : UARTInstance<"UART0", 0x40034000>;
def UART1 : UARTInstance<"UART1", 0x40038000>;

def UARTs : PeripheralGroup<"UARTs", [UART0, UART1]>;

#endif // _RP2040_UART_TD
