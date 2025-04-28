//go:build stm32h7x7

package spi

import (
	"peripheral"
	"peripheral/pin"
	"runtime/arm/cortexm/stm32/stm32h7x7/support/rcc"
	"runtime/arm/cortexm/stm32/stm32h7x7/support/spi"
	"sync"
	"time"
)

type _error int

const (
	errTimeout _error = -1
)

func (e _error) Error() string {
	switch e {
	case 0:
		return "spi: no error"
	case errTimeout:
		return "spi: timeout"
	default:
		return "spi: unknown error"
	}
}

var (
	SPI1 = &_spi{index: 0}
	SPI2 = &_spi{index: 1}
	SPI3 = &_spi{index: 2}
	SPI4 = &_spi{index: 3}
	SPI5 = &_spi{index: 4}
	SPI6 = &_spi{index: 5}
)

type ClockPolarity bool
type ClockPhase bool
type DataFrameOrder bool

type MasterClockDivider uint8

const (
	IdleLow  ClockPolarity = false
	IdleHigh ClockPolarity = true

	LeadingEdge  ClockPhase = false
	TrailingEdge ClockPhase = true

	MSB DataFrameOrder = false
	LSB DataFrameOrder = true

	Div2   MasterClockDivider = 0
	Div4   MasterClockDivider = 1
	Div8   MasterClockDivider = 2
	Div16  MasterClockDivider = 3
	Div32  MasterClockDivider = 4
	Div64  MasterClockDivider = 5
	Div128 MasterClockDivider = 6
	Div256 MasterClockDivider = 7
)

type Config struct {
	DI  pin.Pin
	DO  pin.Pin
	SCK pin.Pin
	CS  pin.Pin

	Polarity     ClockPolarity
	Phase        ClockPhase
	DataOrder    DataFrameOrder
	DataSize     uint8
	ClockDivider MasterClockDivider

	Enabled        bool
	HardwareSelect bool
	SwapDataPins   bool
	Slave          bool
}

type _spi struct {
	cs    pin.Pin
	mutex sync.Mutex
	index uint8
}

const (
	_MOSI = iota + 1
	_MISO
	_SCK
	_SS
)

func altFunction(p pin.Pin, t int, instance *_spi) (mode pin.Mode, err error) {
	tt := 0
	switch instance {
	case SPI1:
		switch p {
		case pin.PA4:
			tt, mode = _SS, pin.Alt5
		case pin.PA5:
			tt, mode = _SCK, pin.Alt5
		case pin.PA6:
			tt, mode = _MISO, pin.Alt5
		case pin.PA7:
			tt, mode = _MOSI, pin.Alt5
		case pin.PA15:
			tt, mode = _SS, pin.Alt5
		case pin.PB3:
			tt, mode = _SCK, pin.Alt5
		case pin.PB4:
			tt, mode = _MISO, pin.Alt5
		case pin.PB5:
			tt, mode = _MOSI, pin.Alt5
		case pin.PD7:
			tt, mode = _MOSI, pin.Alt5
		case pin.PG9:
			tt, mode = _MISO, pin.Alt5
		case pin.PG10:
			tt, mode = _SS, pin.Alt5
		case pin.PG11:
			tt, mode = _SCK, pin.Alt5
		}
	case SPI2:
		switch p {
		case pin.PA9:
			tt, mode = _SCK, pin.Alt5
		case pin.PA11:
			tt, mode = _SS, pin.Alt5
		case pin.PA12:
			tt, mode = _SCK, pin.Alt5
		case pin.PB4:
			tt, mode = _SS, pin.Alt7
		case pin.PB9:
			tt, mode = _SS, pin.Alt5
		case pin.PB10:
			tt, mode = _SCK, pin.Alt5
		case pin.PB12:
			tt, mode = _SS, pin.Alt5
		case pin.PB13:
			tt, mode = _SCK, pin.Alt5
		case pin.PB14:
			tt, mode = _MISO, pin.Alt5
		case pin.PB15:
			tt, mode = _MOSI, pin.Alt5
		case pin.PC1:
			tt, mode = _MOSI, pin.Alt5
		case pin.PC2:
			tt, mode = _MISO, pin.Alt5
		case pin.PC3:
			tt, mode = _MOSI, pin.Alt5
		case pin.PD3:
			tt, mode = _SCK, pin.Alt5
		case pin.PI0:
			tt, mode = _SS, pin.Alt5
		case pin.PI1:
			tt, mode = _SCK, pin.Alt5
		case pin.PI2:
			tt, mode = _MISO, pin.Alt5
		case pin.PI3:
			tt, mode = _MOSI, pin.Alt5
		}
	case SPI3:
		switch p {
		case pin.PA4:
			tt, mode = _SS, pin.Alt6
		case pin.PA15:
			tt, mode = _SS, pin.Alt6
		case pin.PB2:
			tt, mode = _MOSI, pin.Alt7
		case pin.PB3:
			tt, mode = _SCK, pin.Alt6
		case pin.PB4:
			tt, mode = _MISO, pin.Alt6
		case pin.PB5:
			tt, mode = _MOSI, pin.Alt7
		case pin.PC10:
			tt, mode = _SCK, pin.Alt6
		case pin.PC11:
			tt, mode = _MISO, pin.Alt6
		case pin.PC12:
			tt, mode = _MOSI, pin.Alt6
		case pin.PD6:
			tt, mode = _MOSI, pin.Alt5
		}
	case SPI4:
		switch p {
		case pin.PE2:
			tt, mode = _SCK, pin.Alt5
		case pin.PE4:
			tt, mode = _SS, pin.Alt5
		case pin.PE5:
			tt, mode = _MISO, pin.Alt5
		case pin.PE6:
			tt, mode = _MOSI, pin.Alt5
		case pin.PE11:
			tt, mode = _SS, pin.Alt5
		case pin.PE12:
			tt, mode = _SCK, pin.Alt5
		case pin.PE13:
			tt, mode = _MISO, pin.Alt5
		case pin.PE14:
			tt, mode = _MOSI, pin.Alt5
		}
	case SPI5:
		switch p {
		case pin.PF6:
			tt, mode = _SS, pin.Alt5
		case pin.PF7:
			tt, mode = _SCK, pin.Alt5
		case pin.PF8:
			tt, mode = _MISO, pin.Alt5
		case pin.PF9:
			tt, mode = _MOSI, pin.Alt5
		case pin.PF11:
			tt, mode = _MOSI, pin.Alt5
		case pin.PH5:
			tt, mode = _SS, pin.Alt5
		case pin.PH6:
			tt, mode = _SCK, pin.Alt5
		case pin.PH7:
			tt, mode = _MISO, pin.Alt5
		case pin.PJ10:
			tt, mode = _MOSI, pin.Alt5
		case pin.PJ11:
			tt, mode = _MISO, pin.Alt5
		case pin.PK0:
			tt, mode = _SCK, pin.Alt5
		case pin.PK1:
			tt, mode = _SS, pin.Alt5
		}
	case SPI6:
		switch p {
		case pin.PA4:
			tt, mode = _SS, pin.Alt8
		case pin.PA5:
			tt, mode = _SCK, pin.Alt8
		case pin.PA6:
			tt, mode = _MISO, pin.Alt8
		case pin.PA7:
			tt, mode = _MOSI, pin.Alt8
		case pin.PA15:
			tt, mode = _SS, pin.Alt7
		case pin.PB3:
			tt, mode = _SCK, pin.Alt8
		case pin.PB4:
			tt, mode = _MISO, pin.Alt8
		case pin.PB5:
			tt, mode = _MOSI, pin.Alt8
		case pin.PG8:
			tt, mode = _SS, pin.Alt8
		case pin.PG12:
			tt, mode = _MISO, pin.Alt8
		case pin.PG13:
			tt, mode = _SCK, pin.Alt8
		case pin.PG14:
			tt, mode = _MOSI, pin.Alt8
		}
	}

	if mode == 0 || tt != t {
		err = peripheral.ErrInvalidPinout
	}
	return
}

func (s *_spi) Configure(cfg Config) error {
	s.mutex.Lock()
	defer s.mutex.Unlock()

	p := spi.Spi[s.index]

	// Disable the peripheral.
	p.Cr1.SetSpe(false)
	for p.Cr1.GetSpe() {
	}

	if cfg.DataSize < 4 || cfg.DataSize > 32 {
		return peripheral.ErrInvalidConfig
	}

	switch s {
	case SPI4, SPI5, SPI6:
		if cfg.DataSize > 16 {
			return peripheral.ErrInvalidConfig
		}
	}

	// Enable/disable the respective SPI peripheral clock.
	switch s {
	case SPI1:
		rcc.Rcc.Apb2enr.SetSpi1en(cfg.Enabled)
	case SPI2:
		rcc.Rcc.Apb1lenr.SetSpi2en(cfg.Enabled)
	case SPI3:
		rcc.Rcc.Apb1lenr.SetSpi3en(cfg.Enabled)
	case SPI4:
		rcc.Rcc.Apb2enr.SetSpi4en(cfg.Enabled)
	case SPI5:
		rcc.Rcc.Apb2enr.SetSpi5en(cfg.Enabled)
	case SPI6:
		rcc.Rcc.Apb4enr.SetSpi6en(cfg.Enabled)
	}

	if !cfg.Enabled {
		return nil
	}

	// Configure GPIO pins.
	if cfg.DI != 0 {
		if alt, err := altFunction(cfg.DI, _MISO, s); err != nil {
			return err
		} else {
			cfg.DI.SetMode(pin.AltFunction | alt)
		}
		cfg.DI.SetSpeedMode(pin.VeryHighSpeed)
	}

	if cfg.DO != 0 {
		if alt, err := altFunction(cfg.DO, _MOSI, s); err != nil {
			return err
		} else {
			cfg.DO.SetMode(pin.AltFunction | alt)
		}
		cfg.DO.SetOutputMode(pin.PushPull)
		cfg.DO.SetSpeedMode(pin.VeryHighSpeed)
	}

	if cfg.SCK != 0 {
		if alt, err := altFunction(cfg.SCK, _SCK, s); err != nil {
			return err
		} else {
			cfg.SCK.SetMode(pin.AltFunction | alt)
			cfg.SCK.SetSpeedMode(pin.VeryHighSpeed)
		}
	}

	if cfg.CS != 0 {
		if alt, err := altFunction(cfg.CS, _SS, s); err != nil && !cfg.Slave {
			cfg.CS.SetMode(pin.Output)
		} else {
			cfg.CS.SetMode(pin.AltFunction | alt)
		}
		cfg.CS.SetOutputMode(pin.PushPull)
		cfg.CS.SetSpeedMode(pin.VeryHighSpeed)

		s.cs = cfg.CS
	}

	if !cfg.Slave {
		if cfg.HardwareSelect {
			p.Cfg2.SetSsom(false)
			p.Cfg2.SetSsm(false)
			p.Cfg2.SetSsoe(true)
		} else {
			p.Cfg2.SetSsm(true)
		}

		// Configure SS to the correct initial state before initializing the master/slave.
		if p.Cfg2.GetSsm() {
			// SSM = 1 => software NSS management using SSI
			p.Cr1.SetSsi(true)
		} else if !p.Cfg2.GetSsoe() {
			// External CS pin only used when SSOE == 0
			if s.cs != 0 {
				s.cs.Set(true)
			}
		}
	}

	// Set the master or slave mode.
	p.Cfg2.SetMaster(!cfg.Slave)

	p.Cfg1.SetMbr(uint8(cfg.ClockDivider))
	p.Cfg1.SetDsize(cfg.DataSize - 1)
	if cfg.DataSize <= 8 {
		p.Cfg1.SetFthvl(3) // Better to wait for 4+ narrow frames.
	} else if cfg.DataSize <= 16 {
		p.Cfg1.SetFthvl(1) // 16-bit fits 2 per 32-bit access.
	} else {
		p.Cfg1.SetFthvl(0) // Match register length.
	}

	p.Cfg2.SetCpol(bool(cfg.Polarity))
	p.Cfg2.SetCpha(bool(cfg.Phase))
	p.Cfg2.SetLsbfrst(bool(cfg.DataOrder))
	p.Cfg2.SetAfcntr(false) // Only control alt pins when enabled.

	p.Cgfr.SetI2smod(false) // SPI mode.

	// Enable the peripheral.
	p.Cr1.SetSpe(true)
	for !p.Cr1.GetSpe() {
	}

	return nil
}

func (s *_spi) Transact(rx, tx []byte, timeout time.Duration) (int, error) {
	s.mutex.Lock()
	defer s.mutex.Unlock()

	p := spi.Spi[s.index]

	// Validate input
	if len(tx) == 0 || len(rx) == 0 || len(tx) != len(rx) {
		return 0, peripheral.ErrInvalidConfig
	}

	dsize := int(p.Cfg1.GetDsize() + 1)
	packetSize := int(p.Cfg1.GetFthvl() + 1)

	// Determine register access width
	var accessSize int
	switch {
	case dsize <= 8:
		accessSize = 1
	case dsize <= 16:
		accessSize = 2
	default:
		accessSize = 4
	}

	n := len(tx)
	frameCount := n / accessSize
	if n%accessSize != 0 {
		frameCount++ // Round up to cover all bytes
	}

	// Setup transaction size
	p.Cr1.SetSpe(false)
	for p.Cr1.GetSpe() {
	}
	p.Cr2.SetTsize(uint16(frameCount))
	p.Cr1.SetSpe(true)
	p.Cr1.SetCstart(true)

	var txPtr, rxPtr, transferred int
	tstart := time.Now()

	for transferred < n {
		if timeout > 0 && time.Since(tstart) > timeout {
			p.Cr1.SetSpe(false)
			return transferred, errTimeout
		}

		// Transmit a packet
		if p.Sr.GetTxp() && txPtr < n {
			for i := 0; i < packetSize && txPtr < n; i += accessSize {
				switch accessSize {
				case 1:
					p.Txdr.SetTxdr(uint32(tx[txPtr]))
				case 2:
					var val uint16
					val = uint16(tx[txPtr])
					if txPtr+1 < n {
						val |= uint16(tx[txPtr+1]) << 8
					}
					p.Txdr.SetTxdr(uint32(val))
				case 4:
					var val uint32
					val = uint32(tx[txPtr])
					if txPtr+1 < n {
						val |= uint32(tx[txPtr+1]) << 8
					}
					if txPtr+2 < n {
						val |= uint32(tx[txPtr+2]) << 16
					}
					if txPtr+3 < n {
						val |= uint32(tx[txPtr+3]) << 24
					}
					p.Txdr.SetTxdr(val)
				}
				txPtr += accessSize
			}
		}

		// Receive a packet
		if p.Sr.GetRxp() && rxPtr < n {
			for i := 0; i < packetSize && rxPtr < n; i += accessSize {
				val := p.Rxdr.GetRxdr()
				switch accessSize {
				case 1:
					rx[rxPtr] = byte(val)
				case 2:
					rx[rxPtr] = byte(val)
					if rxPtr+1 < n {
						rx[rxPtr+1] = byte(val >> 8)
					}
				case 4:
					rx[rxPtr] = byte(val)
					if rxPtr+1 < n {
						rx[rxPtr+1] = byte(val >> 8)
					}
					if rxPtr+2 < n {
						rx[rxPtr+2] = byte(val >> 16)
					}
					if rxPtr+3 < n {
						rx[rxPtr+3] = byte(val >> 24)
					}
				}
				rxPtr += accessSize
				transferred = rxPtr
			}
		}

		// Final RX fallback for last bytes
		if p.Sr.GetRxwne() && rxPtr < n {
			val := p.Rxdr.GetRxdr()
			switch accessSize {
			case 1:
				rx[rxPtr] = byte(val)
			case 2:
				rx[rxPtr] = byte(val)
				if rxPtr+1 < n {
					rx[rxPtr+1] = byte(val >> 8)
				}
			case 4:
				rx[rxPtr] = byte(val)
				if rxPtr+1 < n {
					rx[rxPtr+1] = byte(val >> 8)
				}
				if rxPtr+2 < n {
					rx[rxPtr+2] = byte(val >> 16)
				}
				if rxPtr+3 < n {
					rx[rxPtr+3] = byte(val >> 24)
				}
			}
			rxPtr += accessSize
			transferred = rxPtr
		}
	}

	// Wait for the end of the transaction
	for !p.Sr.GetEot() {
		if timeout > 0 && time.Since(tstart) > timeout {
			p.Cr1.SetSpe(false)
			return transferred, errTimeout
		}
	}
	p.Ifcr.SetEotc(true)
	p.Cr1.SetSpe(false)

	return transferred, nil
}

func (s *_spi) Select() {
	s.mutex.Lock()
	s.assertCS(false)
	s.mutex.Unlock()
}

func (s *_spi) Deselect() {
	s.mutex.Lock()
	s.assertCS(true)
	s.mutex.Unlock()
}

func (s *_spi) assertCS(on bool) {
	p := spi.Spi[s.index]
	if p.Cfg2.GetMaster() {
		if p.Cfg2.GetSsm() {
			// SSM = 1 => software NSS management using SSI
			p.Cr1.SetSsi(on)
		} else if !p.Cfg2.GetSsoe() {
			// External CS pin only used when SSOE == 0
			if s.cs != 0 {
				s.cs.Set(on)
			}
		}
	}
}
