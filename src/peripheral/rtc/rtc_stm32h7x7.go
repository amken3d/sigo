//go:build stm32h7x7

package rtc

import (
	"runtime/arm/cortexm/stm32/stm32h7x7/support/rcc"
	"runtime/arm/cortexm/stm32/stm32h7x7/support/rtc"
	"time"

	// "runtime/arm/cortexm/stm32/stm32h7x7/support/pwr"

	"omibyte.io/sigo/src/runtime/arm/cortexm/stm32/stm32h7x7/support/pwr"
)

const (
	DefaultAsyncPredivider = 127
	DefaultSyncPredivider  = 255
)

var (
	RTC _rtc
)

type _rtc struct{}

type Config struct {
	Enabled         bool
	AsyncPredivider uint8
	SyncPredivider  uint16
	Now             time.Time
}

func (r *_rtc) Configure(cfg Config) error {
	if cfg.SyncPredivider == 0 {
		cfg.SyncPredivider = DefaultSyncPredivider
	}

	if cfg.AsyncPredivider == 0 {
		cfg.AsyncPredivider = DefaultAsyncPredivider
	}

	// Enable or disable the RTC.
	rcc.Rcc.Bdcr.SetRtcen(cfg.Enabled)

	if !cfg.Enabled {
		return nil
	}

	if pwr.Pwr.Cr1.GetDbp() {
		// Clear the DBP write protection register.
		pwr.Pwr.Cr1.SetDbp(false)
	}

	// Unlock write protection on all RTC registers.
	rtc.Rtc.RtcWpr.SetKey(0xCA)
	rtc.Rtc.RtcWpr.SetKey(0x53)

	// Set the predivider values.
	rtc.Rtc.RtcPrer.SetPredivA(cfg.AsyncPredivider)
	rtc.Rtc.RtcPrer.SetPredivS(cfg.SyncPredivider)

	if !cfg.Now.IsZero() {
		// TODO: Set the initial time.
	}

	return nil
}

func (r *_rtc) Set(t time.Time) {

}

func (r *_rtc) Now() time.Time {
	return time.Time{}
}
