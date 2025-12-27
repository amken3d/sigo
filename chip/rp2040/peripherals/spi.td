// spi.td - RP2040 SPI (PL022)

#ifndef _RP2040_SPI_TD
#define _RP2040_SPI_TD

include "base.td"

def SPIPeripheral : PeripheralType<"SPI", "SPI (PL022)"> {
  let accessWidth = 32;
  let registers = [
    Register<"CR0", 0x00, 32, [
      Field<"DSS", 0, 4, ReadWrite, "Data size select">,
      Field<"FRF", 4, 2, ReadWrite, "Frame format">,
      Field<"SPO", 6, 1, ReadWrite, "Clock polarity">,
      Field<"SPH", 7, 1, ReadWrite, "Clock phase">,
      Field<"SCR", 8, 8, ReadWrite, "Serial clock rate">
    ], "Control register 0">,
    Register<"CR1", 0x04, 32, [
      Field<"LBM", 0, 1, ReadWrite, "Loopback mode">,
      Field<"SSE", 1, 1, ReadWrite, "SPI enable">,
      Field<"MS", 2, 1, ReadWrite, "Master/slave select">,
      Field<"SOD", 3, 1, ReadWrite, "Slave output disable">
    ], "Control register 1">,
    Register<"DR", 0x08, 32, [
      Field<"DATA", 0, 16, ReadWrite, "Data">
    ], "Data register">,
    Register<"SR", 0x0C, 32, [
      Field<"TFE", 0, 1, Read, "TX FIFO empty">,
      Field<"TNF", 1, 1, Read, "TX FIFO not full">,
      Field<"RNE", 2, 1, Read, "RX FIFO not empty">,
      Field<"RFF", 3, 1, Read, "RX FIFO full">,
      Field<"BSY", 4, 1, Read, "SPI busy">
    ], "Status register">,
    Register<"CPSR", 0x10, 32, [
      Field<"CPSDVSR", 0, 8, ReadWrite, "Clock prescale divisor">
    ], "Clock prescale register">,
    Register<"IMSC", 0x14, 32, [
      Field<"RORIM", 0, 1, ReadWrite, "RX overrun interrupt mask">,
      Field<"RTIM", 1, 1, ReadWrite, "RX timeout interrupt mask">,
      Field<"RXIM", 2, 1, ReadWrite, "RX FIFO interrupt mask">,
      Field<"TXIM", 3, 1, ReadWrite, "TX FIFO interrupt mask">
    ], "Interrupt mask">,
    Register<"RIS", 0x18, 32, [], "Raw interrupt status">,
    Register<"MIS", 0x1C, 32, [], "Masked interrupt status">,
    Register<"ICR", 0x20, 32, [], "Interrupt clear">,
    Register<"DMACR", 0x24, 32, [
      Field<"RXDMAE", 0, 1, ReadWrite, "RX DMA enable">,
      Field<"TXDMAE", 1, 1, ReadWrite, "TX DMA enable">
    ], "DMA control">
  ];
}

class SPIInstance<string Name, int Base> : PeripheralInstance<Name, Base, SPIPeripheral>;
def SPI0 : SPIInstance<"SPI0", 0x4003C000>;
def SPI1 : SPIInstance<"SPI1", 0x40040000>;

def SPIs : PeripheralGroup<"SPIs", [SPI0, SPI1]>;

#endif // _RP2040_SPI_TD
