// interrupts.td - ARM Cortex-M system interrupt definitions
// Defines the standard Cortex-M exception/interrupt numbers

#ifndef _ARM_CORTEXM_INTERRUPTS_TD
#define _ARM_CORTEXM_INTERRUPTS_TD

include "base.td"

// Cortex-M system exceptions (negative IRQ numbers, handled separately)
// These are built into the ARM Cortex-M core:
// -14: NMI
// -13: HardFault
// -12: MemManage (M3+)
// -11: BusFault (M3+)
// -10: UsageFault (M3+)
// -5: SVCall
// -2: PendSV
// -1: SysTick

// Device-specific interrupts start at IRQ 0

#endif // _ARM_CORTEXM_INTERRUPTS_TD
