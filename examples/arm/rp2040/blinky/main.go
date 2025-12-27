//go:build rp2040 || pico

// Blinky example for Raspberry Pi Pico (RP2040)
// This example blinks the onboard LED (GPIO25) at 1 Hz.

package main

import (
	_ "pkg.si-go.dev/chip/rp2040"
	"runtime/arm/cortexm/rp2040"
	"time"
	"unsafe"
	"volatile"
)

// GPIO and SIO register addresses
const (
	ioBank0Base = 0x40014000
	sioBase     = 0xD0000000
	padsBank0   = 0x4001C000
	resetsBase  = 0x4000C000
)

// LED is on GPIO25 for Raspberry Pi Pico
const ledPin = 25

func init() {
	// Initialize clocks to 125 MHz
	rp2040.DefaultClocks()

	// Release IO_BANK0 and PADS_BANK0 from reset
	resetDone := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x08)))
	reset := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x00)))

	// Clear reset for IO_BANK0 (bit 5) and PADS_BANK0 (bit 8)
	bits := uint32((1 << 5) | (1 << 8))
	volatile.StoreUint32(reset, volatile.LoadUint32(reset)&^bits)

	// Wait for reset to complete
	for volatile.LoadUint32(resetDone)&bits != bits {
	}
}

func main() {
	// Configure LED pin as SIO (GPIO) output
	configureLedPin()

	// Blink forever
	for {
		setLed(true)
		time.Sleep(time.Millisecond * 500)
		setLed(false)
		time.Sleep(time.Millisecond * 500)
	}
}

// configureLedPin sets up GPIO25 as an output for the LED
func configureLedPin() {
	// Set GPIO function to SIO (5)
	gpioCtrl := (*uint32)(unsafe.Pointer(uintptr(ioBank0Base + (ledPin * 8) + 4)))
	volatile.StoreUint32(gpioCtrl, 5) // FUNCSEL = SIO

	// Enable output on the pad
	padCtrl := (*uint32)(unsafe.Pointer(uintptr(padsBank0 + 4 + (ledPin * 4))))
	volatile.StoreUint32(padCtrl, (1<<6)|(2<<4)) // IE=1, DRIVE=8mA

	// Enable output in SIO
	gpioOeSet := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x24)))
	volatile.StoreUint32(gpioOeSet, 1<<ledPin)
}

// setLed turns the LED on or off
func setLed(on bool) {
	if on {
		gpioOutSet := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x14)))
		volatile.StoreUint32(gpioOutSet, 1<<ledPin)
	} else {
		gpioOutClr := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x18)))
		volatile.StoreUint32(gpioOutClr, 1<<ledPin)
	}
}
