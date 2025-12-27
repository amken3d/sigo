//go:build rp2040 || pico || tinygo.rp2040

// Fibonacci benchmark - measures function call overhead and recursion.
// Computes fib(30) = 832040 using naive recursive algorithm.

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

	// Compute Fibonacci repeatedly
	for {
		ledOn()
		result := fib(30)
		ledOff()

		// Use result to prevent optimization
		if result != 832040 {
			panic("wrong result")
		}
	}
}

// fib computes the nth Fibonacci number recursively.
// This is intentionally naive to stress function calls.
//
//go:noinline
func fib(n int) int {
	if n <= 1 {
		return n
	}
	return fib(n-1) + fib(n-2)
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
