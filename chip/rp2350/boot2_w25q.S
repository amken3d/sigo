// boot2_w25q.S - Second stage bootloader for W25Q flash (Raspberry Pi Pico 2)
// This bootloader configures the QSPI interface for XIP (execute-in-place) mode.
// RP2350 version - uses Cortex-M33 and enhanced QSPI controller.

.syntax unified
.cpu cortex-m33
.thumb

// Register addresses - RP2350 uses different XIP controller
.equ XIP_SSI_BASE,          0x400d0000
.equ SSI_CTRLR0_OFFSET,     0x00
.equ SSI_CTRLR1_OFFSET,     0x04
.equ SSI_SSIENR_OFFSET,     0x08
.equ SSI_BAUDR_OFFSET,      0x14
.equ SSI_SR_OFFSET,         0x28
.equ SSI_DR0_OFFSET,        0x60
.equ SSI_SPI_CTRLR0_OFFSET, 0xf4

.equ PADS_QSPI_BASE,        0x40020000
.equ PADS_QSPI_GPIO_SCLK,   0x04

// CTRLR0 fields
.equ CTRLR0_SPI_FRF_LSB,    21
.equ CTRLR0_DFS_32_LSB,     16
.equ CTRLR0_TMOD_LSB,       8
.equ CTRLR0_TMOD_TX_AND_RX, 0
.equ CTRLR0_TMOD_TX_ONLY,   1
.equ CTRLR0_TMOD_RX_ONLY,   2
.equ CTRLR0_TMOD_EEPROM,    3

// SPI_CTRLR0 fields
.equ SPI_CTRLR0_XIP_CMD_LSB,      24
.equ SPI_CTRLR0_ADDR_L_LSB,       2
.equ SPI_CTRLR0_INST_L_LSB,       8
.equ SPI_CTRLR0_WAIT_CYCLES_LSB,  11
.equ SPI_CTRLR0_TRANS_TYPE_LSB,   0

// Flash commands
.equ CMD_READ_STATUS,       0x05
.equ CMD_READ_STATUS2,      0x35
.equ CMD_WRITE_ENABLE,      0x06
.equ CMD_WRITE_STATUS,      0x01
.equ CMD_READ,              0x03
.equ CMD_FAST_READ_QUAD_IO, 0xEB

// Status register bits
.equ SREG_DATA,             0x02  // QE (Quad Enable) bit in status reg 2

.section .boot2, "ax"
.global __boot2_entry
.type __boot2_entry, %function
__boot2_entry:
    push {lr}

    // Set pad drive strength to 8mA for SCLK
    ldr r3, =PADS_QSPI_BASE
    movs r0, #(2 << 4)          // DRIVE = 8mA
    str r0, [r3, #PADS_QSPI_GPIO_SCLK]

    ldr r3, =XIP_SSI_BASE

    // Disable SSI
    movs r1, #0
    str r1, [r3, #SSI_SSIENR_OFFSET]

    // Set baud rate divider to 4 (for initial setup)
    movs r1, #4
    str r1, [r3, #SSI_BAUDR_OFFSET]

    // Configure for 8-bit, TX+RX mode
    movs r1, #0
    movs r0, #(7 << CTRLR0_DFS_32_LSB)
    orrs r1, r0
    movs r0, #(CTRLR0_TMOD_TX_AND_RX << CTRLR0_TMOD_LSB)
    orrs r1, r0
    str r1, [r3, #SSI_CTRLR0_OFFSET]

    // Enable SSI
    movs r1, #1
    str r1, [r3, #SSI_SSIENR_OFFSET]

    // Check if QE bit is already set in status register 2
    movs r0, #CMD_READ_STATUS2
    bl read_flash_sreg
    movs r2, #SREG_DATA
    tst r0, r2
    bne skip_sreg_programming

    // Need to set QE bit - write enable first
    movs r0, #CMD_WRITE_ENABLE
    bl send_cmd

    // Write status registers 1 and 2 (set QE bit)
    movs r0, #CMD_WRITE_STATUS
    bl send_cmd
    movs r0, #0                 // Status reg 1 = 0
    bl send_cmd
    movs r0, #SREG_DATA         // Status reg 2 = QE bit
    bl send_cmd

    // Wait for write to complete
wait_write:
    movs r0, #CMD_READ_STATUS
    bl read_flash_sreg
    movs r1, #1                 // WIP bit
    tst r0, r1
    bne wait_write

skip_sreg_programming:
    // Disable SSI for reconfiguration
    movs r1, #0
    str r1, [r3, #SSI_SSIENR_OFFSET]

    // Configure for XIP with QSPI
    // CTRLR0: 32-bit data, EEPROM mode, Quad SPI
    ldr r1, =(31 << CTRLR0_DFS_32_LSB) | (CTRLR0_TMOD_EEPROM << CTRLR0_TMOD_LSB) | (2 << CTRLR0_SPI_FRF_LSB)
    str r1, [r3, #SSI_CTRLR0_OFFSET]

    // CTRLR1: 0 data frames (handled by XIP hardware)
    movs r1, #0
    str r1, [r3, #SSI_CTRLR1_OFFSET]

    // SPI_CTRLR0: Quad I/O read, 6 addr cycles, 2 instruction cycles, 4 wait cycles
    ldr r1, =(CMD_FAST_READ_QUAD_IO << SPI_CTRLR0_XIP_CMD_LSB) | (6 << SPI_CTRLR0_ADDR_L_LSB) | (2 << SPI_CTRLR0_INST_L_LSB) | (4 << SPI_CTRLR0_WAIT_CYCLES_LSB) | (2 << SPI_CTRLR0_TRANS_TYPE_LSB)
    ldr r0, =(XIP_SSI_BASE + SSI_SPI_CTRLR0_OFFSET)
    str r1, [r0]

    // Set baud rate to 2 (maximum speed for XIP)
    movs r1, #2
    str r1, [r3, #SSI_BAUDR_OFFSET]

    // Re-enable SSI
    movs r1, #1
    str r1, [r3, #SSI_SSIENR_OFFSET]

    // Jump to main program (vector table at 0x10000100)
    ldr r0, =0x10000100
    ldr r1, [r0]                // Initial stack pointer
    ldr r2, [r0, #4]            // Reset vector
    msr msp, r1
    bx r2

// Send a single command byte
send_cmd:
    str r0, [r3, #SSI_DR0_OFFSET]
wait_tx:
    ldr r1, [r3, #SSI_SR_OFFSET]
    movs r2, #4                 // TFE (TX FIFO empty)
    tst r1, r2
    beq wait_tx
    bx lr

// Read status register (command in r0, result in r0)
read_flash_sreg:
    push {lr}
    bl send_cmd
    // Dummy write to receive
    movs r0, #0
    str r0, [r3, #SSI_DR0_OFFSET]
wait_rx:
    ldr r1, [r3, #SSI_SR_OFFSET]
    movs r2, #8                 // RFNE (RX FIFO not empty)
    tst r1, r2
    beq wait_rx
    // Read and discard first byte (command echo)
    ldr r0, [r3, #SSI_DR0_OFFSET]
    ldr r0, [r3, #SSI_DR0_OFFSET]
    pop {pc}

.size __boot2_entry, . - __boot2_entry

// Pad to 252 bytes
.org 252

// CRC32 placeholder - must be patched by elf2uf2 or boot2 tool
.word 0x00000000
