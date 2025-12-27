//go:build rp2040 || pico || tinygo.rp2040

// Channels benchmark - measures channel send/receive performance.
// Implements a producer-consumer pattern with multiple workers.

package main

import (
	"unsafe"
	"volatile"
)

const (
	sioBase     = 0xD0000000
	ledPin      = 25
	numMessages = 100
	numWorkers  = 2
)

func main() {
	configureLED()

	for {
		work := make(chan int, 10)
		results := make(chan int, numMessages)

		ledOn()

		// Start workers
		for i := 0; i < numWorkers; i++ {
			go worker(work, results)
		}

		// Send work
		go func() {
			for i := 0; i < numMessages; i++ {
				work <- i
			}
			close(work)
		}()

		// Collect results
		sum := 0
		for i := 0; i < numMessages; i++ {
			sum += <-results
		}

		ledOff()

		// Verify: sum of 0..99 doubled = 2 * (99*100/2) = 9900
		if sum != 9900 {
			panic("wrong sum")
		}
	}
}

//go:noinline
func worker(in <-chan int, out chan<- int) {
	for n := range in {
		// Do some "work" - double the number
		out <- n * 2
	}
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
