//go:build stm32h7x7

package rtc

import (
	"runtime/arm/cortexm/stm32/stm32h7x7"
)

func init() {

}

func main() {
	// NOTE: It is recommended that an external low frequency (32.768 KHz) oscillator is used.
	stm32h7x7.EnableLse = true
	stm32h7x7.LseFrequencyHz = 32_768 // Hz
	stm32h7x7.RtcClockSource = stm32h7x7.ClockSourceLse

	// Initialize the clock system.
	stm32h7x7.DefaultClocks()
}
