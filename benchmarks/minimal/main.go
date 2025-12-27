//go:build rp2040 || pico || tinygo.rp2040

// Minimal benchmark - measures absolute minimum binary size.
// This is the smallest possible valid Go program.

package main

func main() {
	// Empty - just measure overhead
	for {
	}
}
