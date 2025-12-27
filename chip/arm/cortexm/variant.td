// variant.td - ARM Cortex-M variant base class
// Provides the base class for Cortex-M microcontroller variants

#ifndef _ARM_CORTEXM_VARIANT_TD
#define _ARM_CORTEXM_VARIANT_TD

include "base.td"

// CortexMVariant - Base class for all Cortex-M microcontroller variants
// Includes standard Cortex-M system interrupts (NMI, HardFault, etc.)
class CortexMVariant<string name, list<MemoryRange> memories,
                     list<Interrupt> deviceInterrupts, MemoryUnit stackSize,
                     list<string> tags = [], string description = "">
    : Variant<name, memories, deviceInterrupts, stackSize, tags, description>;

#endif // _ARM_CORTEXM_VARIANT_TD
