// isr_rp2040.S - Interrupt vector table for RP2040
// This file defines the Cortex-M0+ exception and RP2040 interrupt handlers

.syntax unified
.cpu cortex-m0plus
.thumb

// Default handler - loops forever (can be overridden)
.section .text.DefaultHandler
.global DefaultHandler
.type DefaultHandler, %function
DefaultHandler:
    wfe
    b DefaultHandler
.size DefaultHandler, .-DefaultHandler

// Macro to create weak handler aliases
.macro IRQ handler
    .weak \handler
    .set \handler, DefaultHandler
.endm

// Cortex-M0+ system handlers
IRQ NMI_Handler
IRQ HardFault_Handler
IRQ SVC_Handler
IRQ PendSV_Handler
IRQ SysTick_Handler

// RP2040 device interrupts (IRQ 0-25)
IRQ Timer0Handler
IRQ Timer1Handler
IRQ Timer2Handler
IRQ Timer3Handler
IRQ PwmWrapHandler
IRQ UsbCtrlHandler
IRQ XipHandler
IRQ Pio0Irq0Handler
IRQ Pio0Irq1Handler
IRQ Pio1Irq0Handler
IRQ Pio1Irq1Handler
IRQ DmaIrq0Handler
IRQ DmaIrq1Handler
IRQ IoBank0Handler
IRQ IoQspiHandler
IRQ SioProc0Handler
IRQ SioProc1Handler
IRQ ClocksHandler
IRQ Spi0Handler
IRQ Spi1Handler
IRQ Uart0Handler
IRQ Uart1Handler
IRQ AdcFifoHandler
IRQ I2c0Handler
IRQ I2c1Handler
IRQ RtcHandler

// Vector table
.section .isr_vector, "a", %progbits
.global __isr_vector
.type __isr_vector, %object
__isr_vector:
    // Cortex-M0+ exception vectors
    .long __stack               // 0: Initial stack pointer
    .long Reset_Handler         // 1: Reset handler
    .long NMI_Handler           // 2: NMI handler
    .long HardFault_Handler     // 3: Hard fault handler
    .long 0                     // 4: Reserved
    .long 0                     // 5: Reserved
    .long 0                     // 6: Reserved
    .long 0                     // 7: Reserved
    .long 0                     // 8: Reserved
    .long 0                     // 9: Reserved
    .long 0                     // 10: Reserved
    .long SVC_Handler           // 11: SVCall handler
    .long 0                     // 12: Reserved
    .long 0                     // 13: Reserved
    .long PendSV_Handler        // 14: PendSV handler
    .long SysTick_Handler       // 15: SysTick handler

    // RP2040 device interrupts (IRQ 0-25)
    .long Timer0Handler         // 16: IRQ0  - Timer 0
    .long Timer1Handler         // 17: IRQ1  - Timer 1
    .long Timer2Handler         // 18: IRQ2  - Timer 2
    .long Timer3Handler         // 19: IRQ3  - Timer 3
    .long PwmWrapHandler        // 20: IRQ4  - PWM wrap
    .long UsbCtrlHandler        // 21: IRQ5  - USB controller
    .long XipHandler            // 22: IRQ6  - XIP
    .long Pio0Irq0Handler       // 23: IRQ7  - PIO0 IRQ0
    .long Pio0Irq1Handler       // 24: IRQ8  - PIO0 IRQ1
    .long Pio1Irq0Handler       // 25: IRQ9  - PIO1 IRQ0
    .long Pio1Irq1Handler       // 26: IRQ10 - PIO1 IRQ1
    .long DmaIrq0Handler        // 27: IRQ11 - DMA IRQ0
    .long DmaIrq1Handler        // 28: IRQ12 - DMA IRQ1
    .long IoBank0Handler        // 29: IRQ13 - IO Bank 0
    .long IoQspiHandler         // 30: IRQ14 - IO QSPI
    .long SioProc0Handler       // 31: IRQ15 - SIO Processor 0
    .long SioProc1Handler       // 32: IRQ16 - SIO Processor 1
    .long ClocksHandler         // 33: IRQ17 - Clocks
    .long Spi0Handler           // 34: IRQ18 - SPI0
    .long Spi1Handler           // 35: IRQ19 - SPI1
    .long Uart0Handler          // 36: IRQ20 - UART0
    .long Uart1Handler          // 37: IRQ21 - UART1
    .long AdcFifoHandler        // 38: IRQ22 - ADC FIFO
    .long I2c0Handler           // 39: IRQ23 - I2C0
    .long I2c1Handler           // 40: IRQ24 - I2C1
    .long RtcHandler            // 41: IRQ25 - RTC

.size __isr_vector, .-__isr_vector

// Reset handler - entry point after boot2
.section .text.Reset_Handler
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    // Set stack pointer (already done by boot2, but just in case)
    ldr r0, =__stack
    msr msp, r0

    // Copy .data section from flash to RAM
    ldr r0, =__data_start__
    ldr r1, =__data_end__
    ldr r2, =_sidata
copy_data:
    cmp r0, r1
    bge done_data
    ldr r3, [r2]
    str r3, [r0]
    adds r0, r0, #4
    adds r2, r2, #4
    b copy_data
done_data:

    // Zero .bss section
    ldr r0, =__bss_start__
    ldr r1, =__bss_end__
    movs r2, #0
zero_bss:
    cmp r0, r1
    bge done_bss
    str r2, [r0]
    adds r0, r0, #4
    b zero_bss
done_bss:

    // Call runtime initialization
    bl runtime.init

    // Call main
    bl main.main

    // If main returns, loop forever
hang:
    wfe
    b hang

.size Reset_Handler, .-Reset_Handler
