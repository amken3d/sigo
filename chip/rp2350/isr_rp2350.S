// isr_rp2350.S - Interrupt vector table for RP2350
// This file defines the Cortex-M33 exception and RP2350 interrupt handlers

.syntax unified
.cpu cortex-m33
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

// Cortex-M33 system handlers
IRQ NMI_Handler
IRQ HardFault_Handler
IRQ MemManage_Handler
IRQ BusFault_Handler
IRQ UsageFault_Handler
IRQ SecureFault_Handler
IRQ SVC_Handler
IRQ DebugMon_Handler
IRQ PendSV_Handler
IRQ SysTick_Handler

// RP2350 device interrupts (IRQ 0-51)
IRQ Timer0Irq0Handler
IRQ Timer0Irq1Handler
IRQ Timer0Irq2Handler
IRQ Timer0Irq3Handler
IRQ Timer1Irq0Handler
IRQ Timer1Irq1Handler
IRQ Timer1Irq2Handler
IRQ Timer1Irq3Handler
IRQ PwmWrap0Handler
IRQ PwmWrap1Handler
IRQ DmaIrq0Handler
IRQ DmaIrq1Handler
IRQ DmaIrq2Handler
IRQ DmaIrq3Handler
IRQ UsbCtrlHandler
IRQ Pio0Irq0Handler
IRQ Pio0Irq1Handler
IRQ Pio1Irq0Handler
IRQ Pio1Irq1Handler
IRQ Pio2Irq0Handler
IRQ Pio2Irq1Handler
IRQ IoBank0Handler
IRQ IoBank0NsHandler
IRQ IoQspiHandler
IRQ IoQspiNsHandler
IRQ SioFifoHandler
IRQ SioBellHandler
IRQ SioFifoNsHandler
IRQ SioBellNsHandler
IRQ SioMtimecmpHandler
IRQ ClocksHandler
IRQ Spi0Handler
IRQ Spi1Handler
IRQ Uart0Handler
IRQ Uart1Handler
IRQ AdcFifoHandler
IRQ I2c0Handler
IRQ I2c1Handler
IRQ OtpHandler
IRQ TrngHandler
IRQ Proc0CtiHandler
IRQ Proc1CtiHandler
IRQ PllSysHandler
IRQ PllUsbHandler
IRQ PowmanPowHandler
IRQ PowmanTimerHandler
IRQ SpareIrq0Handler
IRQ SpareIrq1Handler
IRQ SpareIrq2Handler
IRQ SpareIrq3Handler
IRQ SpareIrq4Handler
IRQ SpareIrq5Handler

// Vector table
.section .isr_vector, "a", %progbits
.global __isr_vector
.type __isr_vector, %object
__isr_vector:
    // Cortex-M33 exception vectors
    .long __stack               // 0: Initial stack pointer
    .long Reset_Handler         // 1: Reset handler
    .long NMI_Handler           // 2: NMI handler
    .long HardFault_Handler     // 3: Hard fault handler
    .long MemManage_Handler     // 4: Memory management fault
    .long BusFault_Handler      // 5: Bus fault
    .long UsageFault_Handler    // 6: Usage fault
    .long SecureFault_Handler   // 7: Secure fault (TrustZone)
    .long 0                     // 8: Reserved
    .long 0                     // 9: Reserved
    .long 0                     // 10: Reserved
    .long SVC_Handler           // 11: SVCall handler
    .long DebugMon_Handler      // 12: Debug monitor
    .long 0                     // 13: Reserved
    .long PendSV_Handler        // 14: PendSV handler
    .long SysTick_Handler       // 15: SysTick handler

    // RP2350 device interrupts (IRQ 0-51)
    .long Timer0Irq0Handler     // 16: IRQ0
    .long Timer0Irq1Handler     // 17: IRQ1
    .long Timer0Irq2Handler     // 18: IRQ2
    .long Timer0Irq3Handler     // 19: IRQ3
    .long Timer1Irq0Handler     // 20: IRQ4
    .long Timer1Irq1Handler     // 21: IRQ5
    .long Timer1Irq2Handler     // 22: IRQ6
    .long Timer1Irq3Handler     // 23: IRQ7
    .long PwmWrap0Handler       // 24: IRQ8
    .long PwmWrap1Handler       // 25: IRQ9
    .long DmaIrq0Handler        // 26: IRQ10
    .long DmaIrq1Handler        // 27: IRQ11
    .long DmaIrq2Handler        // 28: IRQ12
    .long DmaIrq3Handler        // 29: IRQ13
    .long UsbCtrlHandler        // 30: IRQ14
    .long Pio0Irq0Handler       // 31: IRQ15
    .long Pio0Irq1Handler       // 32: IRQ16
    .long Pio1Irq0Handler       // 33: IRQ17
    .long Pio1Irq1Handler       // 34: IRQ18
    .long Pio2Irq0Handler       // 35: IRQ19
    .long Pio2Irq1Handler       // 36: IRQ20
    .long IoBank0Handler        // 37: IRQ21
    .long IoBank0NsHandler      // 38: IRQ22
    .long IoQspiHandler         // 39: IRQ23
    .long IoQspiNsHandler       // 40: IRQ24
    .long SioFifoHandler        // 41: IRQ25
    .long SioBellHandler        // 42: IRQ26
    .long SioFifoNsHandler      // 43: IRQ27
    .long SioBellNsHandler      // 44: IRQ28
    .long SioMtimecmpHandler    // 45: IRQ29
    .long ClocksHandler         // 46: IRQ30
    .long Spi0Handler           // 47: IRQ31
    .long Spi1Handler           // 48: IRQ32
    .long Uart0Handler          // 49: IRQ33
    .long Uart1Handler          // 50: IRQ34
    .long AdcFifoHandler        // 51: IRQ35
    .long I2c0Handler           // 52: IRQ36
    .long I2c1Handler           // 53: IRQ37
    .long OtpHandler            // 54: IRQ38
    .long TrngHandler           // 55: IRQ39
    .long Proc0CtiHandler       // 56: IRQ40
    .long Proc1CtiHandler       // 57: IRQ41
    .long PllSysHandler         // 58: IRQ42
    .long PllUsbHandler         // 59: IRQ43
    .long PowmanPowHandler      // 60: IRQ44
    .long PowmanTimerHandler    // 61: IRQ45
    .long SpareIrq0Handler      // 62: IRQ46
    .long SpareIrq1Handler      // 63: IRQ47
    .long SpareIrq2Handler      // 64: IRQ48
    .long SpareIrq3Handler      // 65: IRQ49
    .long SpareIrq4Handler      // 66: IRQ50
    .long SpareIrq5Handler      // 67: IRQ51

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

    // Enable FPU (Cortex-M33 has optional FPU)
    ldr r0, =0xE000ED88         // CPACR
    ldr r1, [r0]
    orr r1, r1, #(0xF << 20)    // Enable CP10 and CP11 (FPU)
    str r1, [r0]
    dsb
    isb

    // Call runtime initialization
    bl runtime.init

    // Call main
    bl main.main

    // If main returns, loop forever
hang:
    wfe
    b hang

.size Reset_Handler, .-Reset_Handler
