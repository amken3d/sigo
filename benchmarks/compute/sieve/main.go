//go:build rp2040 || pico || tinygo.rp2040

// Sieve benchmark - measures array access and loop performance.
// Computes prime numbers up to N using Sieve of Eratosthenes.

package main

import (
	"unsafe"
	"volatile"
)

const (
	sioBase = 0xD0000000
	ledPin  = 25
	// Sieve size - adjust based on available RAM
	// RP2040 has 264KB, so 10000 bytes is safe
	sieveSize = 10000
)

func main() {
	configureLED()

	for {
		ledOn()
		count := sieve(sieveSize)
		ledOff()

		// Expected: 1229 primes below 10000
		if count != 1229 {
			panic("wrong result")
		}
	}
}

// sieve computes the number of primes up to n using Sieve of Eratosthenes.
//
//go:noinline
func sieve(n int) int {
	// Allocate on stack for small sizes
	var primes [sieveSize]bool

	// Initialize all to true
	for i := 0; i < n; i++ {
		primes[i] = true
	}

	// Mark non-primes
	for i := 2; i*i < n; i++ {
		if primes[i] {
			for j := i * i; j < n; j += i {
				primes[j] = false
			}
		}
	}

	// Count primes
	count := 0
	for i := 2; i < n; i++ {
		if primes[i] {
			count++
		}
	}

	return count
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
