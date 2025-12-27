//go:build rp2040 || pico || pico_w

// Package rp2040 provides runtime support for the Raspberry Pi RP2040 microcontroller.
package rp2040

import (
	"unsafe"
	"volatile"
)

// Register addresses
const (
	resetsBase  = 0x4000C000
	clocksBase  = 0x40008000
	xoscBase    = 0x40024000
	pllSysBase  = 0x40028000
	pllUsbBase  = 0x4002C000
	watchdogBase = 0x40058000
)

// Resets register offsets
const (
	resetsReset     = resetsBase + 0x00
	resetsResetDone = resetsBase + 0x08
)

// XOSC register offsets
const (
	xoscCtrl    = xoscBase + 0x00
	xoscStatus  = xoscBase + 0x04
	xoscStartup = xoscBase + 0x0C
)

// PLL register offsets
const (
	pllCs       = 0x00
	pllPwr      = 0x04
	pllFbdivInt = 0x08
	pllPrim     = 0x0C
)

// Clocks register offsets
const (
	clkRefCtrl      = clocksBase + 0x30
	clkRefDiv       = clocksBase + 0x34
	clkRefSelected  = clocksBase + 0x38
	clkSysCtrl      = clocksBase + 0x3C
	clkSysDiv       = clocksBase + 0x40
	clkSysSelected  = clocksBase + 0x44
	clkPeriCtrl     = clocksBase + 0x48
	clkUsbCtrl      = clocksBase + 0x54
	clkUsbDiv       = clocksBase + 0x58
	clkAdcCtrl      = clocksBase + 0x60
	clkAdcDiv       = clocksBase + 0x64
)

// Watchdog register offsets
const (
	watchdogTick = watchdogBase + 0x2C
)

// Clock constants
const (
	xoscFreq     = 12_000_000  // 12 MHz crystal on Pico
	pllSysVcoMin = 750_000_000 // VCO minimum frequency
	pllSysVcoMax = 1_600_000_000 // VCO maximum frequency
)

// DefaultClocks configures the RP2040 clocks for standard operation:
// - System clock: 125 MHz (from PLL_SYS)
// - USB clock: 48 MHz (from PLL_USB)
// - Peripheral clock: 125 MHz (from system clock)
func DefaultClocks() {
	// Reset subsystems we'll be configuring
	resetSubsystem(1<<12 | 1<<13) // PLL_SYS | PLL_USB

	// Start the crystal oscillator
	initXosc()

	// Configure PLL_SYS for 125 MHz (12 MHz * 125 / 6 / 2 = 125 MHz)
	initPll(pllSysBase, 1, 125, 6, 2)

	// Configure PLL_USB for 48 MHz (12 MHz * 100 / 5 / 5 = 48 MHz)
	initPll(pllUsbBase, 1, 100, 5, 5)

	// Switch clocks to use PLLs
	// Reference clock: XOSC
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkRefCtrl))), 2) // src = xosc
	for volatile.LoadUint32((*uint32)(unsafe.Pointer(uintptr(clkRefSelected))))&(1<<2) == 0 {
	}

	// System clock: PLL_SYS via aux
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkSysCtrl))), 0) // src = ref
	for volatile.LoadUint32((*uint32)(unsafe.Pointer(uintptr(clkSysSelected))))&1 == 0 {
	}
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkSysCtrl))), 1|(0<<5)) // src = aux, auxsrc = pll_sys
	for volatile.LoadUint32((*uint32)(unsafe.Pointer(uintptr(clkSysSelected))))&(1<<1) == 0 {
	}

	// Peripheral clock: from system clock
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkPeriCtrl))), (1<<11)|(4<<5)) // enable, auxsrc = clk_sys

	// USB clock: PLL_USB
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkUsbDiv))), 1<<8) // div = 1
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkUsbCtrl))), (1<<11)|(0<<5)) // enable, auxsrc = pll_usb

	// ADC clock: from USB PLL (48 MHz)
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkAdcDiv))), 1<<8) // div = 1
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(clkAdcCtrl))), (1<<11)|(0<<5)) // enable, auxsrc = pll_usb

	// Configure watchdog tick (1 μs ticks at 12 MHz ref clock = 12 cycles)
	volatile.StoreUint32((*uint32)(unsafe.Pointer(uintptr(watchdogTick))), 12|(1<<9)) // cycles = 12, enable
}

// resetSubsystem resets the specified subsystems and waits for reset to complete
func resetSubsystem(bits uint32) {
	reset := (*uint32)(unsafe.Pointer(uintptr(resetsReset)))
	done := (*uint32)(unsafe.Pointer(uintptr(resetsResetDone)))

	// Assert reset
	volatile.StoreUint32(reset, volatile.LoadUint32(reset)|bits)

	// Deassert reset
	volatile.StoreUint32(reset, volatile.LoadUint32(reset)&^bits)

	// Wait for reset to complete
	for volatile.LoadUint32(done)&bits != bits {
	}
}

// initXosc initializes the crystal oscillator
func initXosc() {
	ctrl := (*uint32)(unsafe.Pointer(uintptr(xoscCtrl)))
	status := (*uint32)(unsafe.Pointer(uintptr(xoscStatus)))
	startup := (*uint32)(unsafe.Pointer(uintptr(xoscStartup)))

	// Configure startup delay (default is fine for 12 MHz crystal)
	volatile.StoreUint32(startup, 47) // ~1ms at ring oscillator frequency

	// Enable XOSC
	volatile.StoreUint32(ctrl, 0xAA0|(0xFAB<<12)) // freq_range = 1_15mhz, enable

	// Wait for XOSC to stabilize
	for volatile.LoadUint32(status)&(1<<31) == 0 {
	}
}

// initPll initializes a PLL with the specified parameters
// Output frequency = (ref_freq / refdiv) * fbdiv / postdiv1 / postdiv2
func initPll(base uintptr, refdiv, fbdiv, postdiv1, postdiv2 uint32) {
	cs := (*uint32)(unsafe.Pointer(base + pllCs))
	pwr := (*uint32)(unsafe.Pointer(base + pllPwr))
	fbdivReg := (*uint32)(unsafe.Pointer(base + pllFbdivInt))
	prim := (*uint32)(unsafe.Pointer(base + pllPrim))

	// Set reference divider
	volatile.StoreUint32(cs, refdiv)

	// Set feedback divider
	volatile.StoreUint32(fbdivReg, fbdiv)

	// Power on PLL (power down = 0)
	volatile.StoreUint32(pwr, 0)

	// Wait for PLL to lock
	for volatile.LoadUint32(cs)&(1<<31) == 0 {
	}

	// Set post dividers
	volatile.StoreUint32(prim, (postdiv1<<16)|(postdiv2<<12))
}
