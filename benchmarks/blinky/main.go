//go:build rp2040 || pico || tinygo.rp2040

// Blinky benchmark - measures basic GPIO performance and code size.
// Toggles LED as fast as possible to measure GPIO overhead.

package main

import (
	"unsafe"
	"volatile"
)

const (
	sioBase = 0xD0000000
	ledPin  = 25
)

func main() {
	configureLED()

	// Toggle LED in tight loop - measure with logic analyzer
	gpioXor := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x1C)))
	mask := uint32(1 << ledPin)

	for {
		volatile.StoreUint32(gpioXor, mask)
	}
}

func configureLED() {
	// Release GPIO from reset
	const resetsBase = 0x4000C000
	reset := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x00)))
	resetDone := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x08)))

	bits := uint32((1 << 5) | (1 << 8)) // IO_BANK0 | PADS_BANK0
	volatile.StoreUint32(reset, volatile.LoadUint32(reset)&^bits)
	for volatile.LoadUint32(resetDone)&bits != bits {
	}

	// Set GPIO function to SIO
	const ioBank0Base = 0x40014000
	gpioCtrl := (*uint32)(unsafe.Pointer(uintptr(ioBank0Base + (ledPin * 8) + 4)))
	volatile.StoreUint32(gpioCtrl, 5) // FUNCSEL = SIO

	// Enable output
	gpioOeSet := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x24)))
	volatile.StoreUint32(gpioOeSet, 1<<ledPin)
}
