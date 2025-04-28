//go:build generic

package sdio

import (
	"io"
)

type SDIO interface {
	io.ReadWriter
}
