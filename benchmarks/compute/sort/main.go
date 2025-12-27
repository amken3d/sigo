//go:build rp2040 || pico || tinygo.rp2040

// Sort benchmark - measures slice operations and memory management.
// Sorts an array of integers using quicksort.

package main

import (
	"unsafe"
	"volatile"
)

const (
	sioBase   = 0xD0000000
	ledPin    = 25
	arraySize = 1000
)

func main() {
	configureLED()

	// Create test data
	var data [arraySize]int

	for {
		// Initialize with pseudo-random values (deterministic for verification)
		seed := 12345
		for i := 0; i < arraySize; i++ {
			seed = (seed*1103515245 + 12345) & 0x7FFFFFFF
			data[i] = seed % 10000
		}

		ledOn()
		quicksort(data[:], 0, arraySize-1)
		ledOff()

		// Verify sorted
		if !isSorted(data[:]) {
			panic("not sorted")
		}
	}
}

// quicksort sorts the slice in place.
//
//go:noinline
func quicksort(arr []int, low, high int) {
	if low < high {
		p := partition(arr, low, high)
		quicksort(arr, low, p-1)
		quicksort(arr, p+1, high)
	}
}

func partition(arr []int, low, high int) int {
	pivot := arr[high]
	i := low - 1

	for j := low; j < high; j++ {
		if arr[j] <= pivot {
			i++
			arr[i], arr[j] = arr[j], arr[i]
		}
	}

	arr[i+1], arr[high] = arr[high], arr[i+1]
	return i + 1
}

func isSorted(arr []int) bool {
	for i := 1; i < len(arr); i++ {
		if arr[i-1] > arr[i] {
			return false
		}
	}
	return true
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
