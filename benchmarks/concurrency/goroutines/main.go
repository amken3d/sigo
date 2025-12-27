//go:build rp2040 || pico || tinygo.rp2040

// Goroutines benchmark - measures goroutine spawn/schedule overhead.
// Creates multiple goroutines that each do a small amount of work.

package main

import (
	"unsafe"
	"volatile"
)

const (
	sioBase       = 0xD0000000
	ledPin        = 25
	numGoroutines = 10
	workPerGo     = 1000
)

var (
	counter  int
	finished int
)

func main() {
	configureLED()

	for {
		counter = 0
		finished = 0

		ledOn()

		// Spawn goroutines
		for i := 0; i < numGoroutines; i++ {
			go worker(i)
		}

		// Wait for all to finish
		for finished < numGoroutines {
			// Yield to scheduler
		}

		ledOff()

		// Verify all work was done
		expected := numGoroutines * workPerGo
		if counter != expected {
			panic("wrong count")
		}
	}
}

//go:noinline
func worker(id int) {
	for i := 0; i < workPerGo; i++ {
		counter++
	}
	finished++
}

func configureLED() {
	const resetsBase = 0x4000C000
	reset := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x00)))
	resetDone := (*uint32)(unsafe.Pointer(uintptr(resetsBase + 0x08)))

	bits := uint32((1 << 5) | (1 << 8))
	volatile.StoreUint32(reset, volatile.LoadUint32(reset)&^bits)
	for volatile.LoadUint32(resetDone)&bits != bits {
	}

	const ioBank0Base = 0x40014000
	gpioCtrl := (*uint32)(unsafe.Pointer(uintptr(ioBank0Base + (ledPin * 8) + 4)))
	volatile.StoreUint32(gpioCtrl, 5)

	gpioOeSet := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x24)))
	volatile.StoreUint32(gpioOeSet, 1<<ledPin)
}

func ledOn() {
	gpioSet := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x14)))
	volatile.StoreUint32(gpioSet, 1<<ledPin)
}

func ledOff() {
	gpioClr := (*uint32)(unsafe.Pointer(uintptr(sioBase + 0x18)))
	volatile.StoreUint32(gpioClr, 1<<ledPin)
}
