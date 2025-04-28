//go:build stm32h7x7

package sdio

import (
	"peripheral"
	"peripheral/pin"
	"peripheral/sdio"
	"runtime/arm/cortexm/stm32/stm32h7x7/support/rcc"
	"runtime/arm/cortexm/stm32/stm32h7x7/support/sdmmc"
)

var (
	SDIO1 = &_sdio{index: 0}
	SDIO2 = &_sdio{index: 1}
)

type _sdio struct {
	index uint8
}

type Config struct {
	Enabled bool
	D0      pin.Pin
	D1      pin.Pin
	D2      pin.Pin
	D3      pin.Pin
	D4      pin.Pin
	D5      pin.Pin
	D6      pin.Pin
	D7      pin.Pin
	CK      pin.Pin
	CMD     pin.Pin

	CKIN    pin.Pin
	CDIR    pin.Pin
	D0DIR   pin.Pin
	D123DIR pin.Pin
}

const (
	_D0 uint8 = iota + 1
	_D1
	_D2
	_D3
	_D4
	_D5
	_D6
	_D7
	_CK
	_CMD
	_CKIN
	_CDIR
	_D0DIR
	_D123DIR
)

func altFunction(p pin.Pin, t uint8, instance *_sdio) (mode pin.Mode, err error) {
	var tt uint8 = 0
	switch instance {
	case SDIO1:
		switch p {
		case pin.PB8:
			switch t {
			case _CKIN:
				tt, mode = _CKIN, pin.Alt7
			case _D4:
				tt, mode = _D4, pin.Alt12
			}
		case pin.PB9:
			switch t {
			case _CDIR:
				tt, mode = _CDIR, pin.Alt7
			case _D5:
				tt, mode = _D5, pin.Alt12
			}
		case pin.PC6:
			switch t {
			case _D0DIR:
				tt, mode = _D0DIR, pin.Alt8
			case _D6:
				tt, mode = _D6, pin.Alt12
			}
		case pin.PC7:
			switch t {
			case _D123DIR:
				tt, mode = _D123DIR, pin.Alt8
			case _D7:
				tt, mode = _D7, pin.Alt12
			}
		case pin.PC8:
			tt, mode = _D0, pin.Alt12
		case pin.PC9:
			tt, mode = _D1, pin.Alt12
		case pin.PC10:
			tt, mode = _D2, pin.Alt12
		case pin.PC11:
			tt, mode = _D3, pin.Alt12
		case pin.PC12:
			tt, mode = _CK, pin.Alt12
		case pin.PD2:
			tt, mode = _CMD, pin.Alt12
		}
	case SDIO2:
		switch p {
		case pin.PA0:
			tt, mode = _CMD, pin.Alt9
		case pin.PB3:
			tt, mode = _D2, pin.Alt9
		case pin.PB4:
			tt, mode = _D3, pin.Alt9
		case pin.PB8:
			tt, mode = _D4, pin.Alt10
		case pin.PB9:
			tt, mode = _D5, pin.Alt10
		case pin.PB14:
			tt, mode = _D0, pin.Alt9
		case pin.PB15:
			tt, mode = _D1, pin.Alt9
		case pin.PC1:
			tt, mode = _CK, pin.Alt9
		case pin.PC6:
			tt, mode = _D6, pin.Alt10
		case pin.PC7:
			tt, mode = _D7, pin.Alt10
		case pin.PD6:
			tt, mode = _CK, pin.Alt11
		case pin.PD7:
			tt, mode = _CMD, pin.Alt11
		case pin.PG11:
			tt, mode = _D2, pin.Alt10
		}
	}

	if mode == 0 || tt != t {
		return 0, peripheral.ErrInvalidPinout
	}
	return
}

func (s *_sdio) Configure(cfg Config) error {
	p := sdmmc.Sdmmc[s.index]

	// Reset the peripheral first.
	switch s {
	case SDIO1:
		rcc.Rcc.Ahb3rstr.SetSdmmc1rst(true)
	case SDIO2:
		rcc.Rcc.Ahb2rstr.SetSdmmc2rst(true)
	}

	// Disable the Vcc power to the card.
	// Set the SDMMC in power-cycle state. This makes that the SDMMC_D[7:0], SDMMC_CMD and SDMMC_CK are driven low, to prevent the card from being supplied through the signal lines.
	// After minimum 1 ms enable the Vcc power to the card.
	// After the power ramp period set the SDMMC to the power-off state for minimum 1 ms. The SDMMC_D[7:0], SDMMC_CMD and SDMMC_CK are set to drive “1”.
	// After the 1 ms delay set the SDMMC to power-on state in which the SDMMC_CK clock is enabled.
	// After 74 SDMMC_CK cycles the first command can be sent to the card.

	switch s {
	case SDIO1:
		rcc.Rcc.Ahb3enr.SetSdmmc1en(cfg.Enabled)
	case SDIO2:
		rcc.Rcc.Ahb2enr.SetSdmmc2en(cfg.Enabled)
	}

	if !cfg.Enabled {
		return nil
	}

	return nil
}
