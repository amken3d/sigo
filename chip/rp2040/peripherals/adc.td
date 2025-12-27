// adc.td - RP2040 ADC

#ifndef _RP2040_ADC_TD
#define _RP2040_ADC_TD

include "base.td"

def ADCPeripheral : PeripheralType<"ADC", "Analog to Digital Converter"> {
  let accessWidth = 32;
  let registers = [
    Register<"CS", 0x00, 32, [
      Field<"EN", 0, 1, ReadWrite, "ADC enable">,
      Field<"TS_EN", 1, 1, ReadWrite, "Temperature sensor enable">,
      Field<"START_ONCE", 2, 1, Write, "Start single conversion">,
      Field<"START_MANY", 3, 1, ReadWrite, "Start continuous conversion">,
      Field<"READY", 8, 1, Read, "Conversion ready">,
      Field<"ERR", 9, 1, ReadWrite, "Error flag">,
      Field<"ERR_STICKY", 10, 1, ReadWrite, "Sticky error flag">,
      Field<"AINSEL", 12, 3, ReadWrite, "Input channel select">,
      Field<"RROBIN", 16, 5, ReadWrite, "Round-robin channel mask">
    ], "Control and status">,
    Register<"RESULT", 0x04, 32, [
      Field<"RESULT", 0, 12, Read, "Conversion result">
    ], "Conversion result">,
    Register<"FCS", 0x08, 32, [
      Field<"EN", 0, 1, ReadWrite, "FIFO enable">,
      Field<"SHIFT", 1, 1, ReadWrite, "Right-shift result">,
      Field<"ERR", 2, 1, ReadWrite, "Error in FIFO">,
      Field<"DREQ_EN", 3, 1, ReadWrite, "DMA request enable">,
      Field<"EMPTY", 8, 1, Read, "FIFO empty">,
      Field<"FULL", 9, 1, Read, "FIFO full">,
      Field<"UNDER", 10, 1, ReadWrite, "Underflow flag">,
      Field<"OVER", 11, 1, ReadWrite, "Overflow flag">,
      Field<"LEVEL", 16, 4, Read, "FIFO level">,
      Field<"THRESH", 24, 4, ReadWrite, "FIFO threshold">
    ], "FIFO control and status">,
    Register<"FIFO", 0x0C, 32, [
      Field<"VAL", 0, 12, Read, "FIFO data">,
      Field<"ERR", 15, 1, Read, "Error flag">
    ], "FIFO data">,
    Register<"DIV", 0x10, 32, [
      Field<"FRAC", 0, 8, ReadWrite, "Fractional divider">,
      Field<"INT", 8, 16, ReadWrite, "Integer divider">
    ], "Clock divider">,
    Register<"INTR", 0x14, 32, [
      Field<"FIFO", 0, 1, Read, "FIFO interrupt">
    ], "Raw interrupt">,
    Register<"INTE", 0x18, 32, [
      Field<"FIFO", 0, 1, ReadWrite, "FIFO interrupt enable">
    ], "Interrupt enable">,
    Register<"INTF", 0x1C, 32, [], "Interrupt force">,
    Register<"INTS", 0x20, 32, [], "Interrupt status">
  ];
}

class ADCInstance<string Name, int Base> : PeripheralInstance<Name, Base, ADCPeripheral>;
def ADC : ADCInstance<"ADC", 0x4004C000>;

#endif // _RP2040_ADC_TD
