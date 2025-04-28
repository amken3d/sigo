//go:build stm32h7x7

package main

import (
	"peripheral/pin"
	"peripheral/spi"
	"peripheral/uart"
	"runtime/arm/cortexm/stm32/stm32h7x7"
	"time"
)

var (
	SPI  = spi.SPI5
	UART = uart.UART1
)

func main() {
	// Initialize the clock system.
	stm32h7x7.DefaultClocks()

	// Configure UART.
	UART.Configure(uart.Config{
		Enable:          true,
		TX:              pin.PA9,
		RX:              pin.PB7,
		Baud:            115_200,
		CharacterSize:   8,
		NumStopBits:     1,
		ReceiveEnabled:  true,
		TransmitEnabled: true,
	})

	// Configure the SPI master.
	if err := SPI.Configure(spi.Config{
		Enabled:  true,
		DI:       pin.PJ11,
		DO:       pin.PJ10,
		DataSize: 8,
	}); err != nil {
		UART.WriteString(err.Error())
		UART.WriteString("\n")
		panic(err)
	}

	var c byte = 0
	for {
		tx := []byte{c}
		rx := make([]byte, 1)
		if n, err := SPI.Transact(rx, tx, time.Second); err != nil {
			UART.WriteString(err.Error())
			UART.WriteString("\n")
		} else if n == 0 {
			UART.WriteString("no transaction occurred\n")
		} else {
			UART.WriteString("sent ")
			UART.WriteString(string(tx))
			UART.WriteString("\n")
			UART.WriteString("received ")
			UART.WriteString(string(rx))
			UART.WriteString("\n")
		}
		c++
	}
}
