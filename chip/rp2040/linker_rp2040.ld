/* linker_rp2040.ld - RP2040 Linker Script with boot2 support */

MEMORY
{
    BOOT2 (rx)  : ORIGIN = 0x10000000, LENGTH = 256
    FLASH (rx)  : ORIGIN = 0x10000100, LENGTH = 2048K - 256
    SRAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 264K
}

__stack_size = 2K;

ENTRY(Reset_Handler)

SECTIONS
{
    /* Second stage bootloader - must be first 256 bytes */
    .boot2 : {
        __boot2_start__ = .;
        KEEP(*(.boot2))
        . = ALIGN(4);
        __boot2_end__ = .;
    } > BOOT2

    /* Vector table */
    .isr_vector : {
        . = ALIGN(256);
        __isr_vector_start__ = .;
        KEEP(*(.isr_vector))
        . = ALIGN(4);
        __isr_vector_end__ = .;
    } > FLASH

    /* Program code */
    .text : {
        . = ALIGN(4);
        __text_start__ = .;
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
        __text_end__ = .;
    } > FLASH

    /* ARM exception unwinding */
    .ARM.extab : {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH

    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } > FLASH

    /* Constructors */
    .preinit_array : {
        PROVIDE_HIDDEN(__preinit_array_start = .);
        KEEP(*(.preinit_array*))
        PROVIDE_HIDDEN(__preinit_array_end = .);
    } > FLASH

    .init_array : {
        PROVIDE_HIDDEN(__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array*))
        PROVIDE_HIDDEN(__init_array_end = .);
    } > FLASH

    .fini_array : {
        PROVIDE_HIDDEN(__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array*))
        PROVIDE_HIDDEN(__fini_array_end = .);
    } > FLASH

    /* End of text/flash */
    _sidata = LOADADDR(.data);
    __etext = .;

    /* Initialized data - copied from flash to RAM at startup */
    .data : {
        . = ALIGN(4);
        __data_start__ = .;
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        __data_end__ = .;
        _edata = .;
    } > SRAM AT > FLASH

    /* Uninitialized data - zeroed at startup */
    .bss (NOLOAD) : {
        . = ALIGN(4);
        __bss_start__ = .;
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
        _ebss = .;
    } > SRAM

    /* Heap */
    .heap (NOLOAD) : {
        . = ALIGN(8);
        __heap_start__ = .;
        _sheap = .;
        . = . + (LENGTH(SRAM) - __stack_size - SIZEOF(.data) - SIZEOF(.bss) - 1K);
        . = ALIGN(8);
        __heap_end__ = .;
        _eheap = .;
    } > SRAM

    /* Stack - at end of RAM */
    .stack (NOLOAD) : {
        . = ALIGN(8);
        __stack_end__ = .;
        . = . + __stack_size;
        . = ALIGN(8);
        __stack = .;
        _estack = .;
    } > SRAM

    /* Provide symbols for runtime */
    PROVIDE(__flash_start = ORIGIN(FLASH));
    PROVIDE(__flash_end = ORIGIN(FLASH) + LENGTH(FLASH));
    PROVIDE(__ram_start = ORIGIN(SRAM));
    PROVIDE(__ram_end = ORIGIN(SRAM) + LENGTH(SRAM));

    /* Scratch memory for inter-core communication */
    .scratch_x (NOLOAD) : {
        *(.scratch_x.*)
    } > SRAM

    .scratch_y (NOLOAD) : {
        *(.scratch_y.*)
    } > SRAM

    /* Discard unwanted sections */
    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}

/* Assertions */
ASSERT(__boot2_end__ - __boot2_start__ == 256, "Boot2 must be exactly 256 bytes")
ASSERT(__stack >= __heap_end__, "Stack overlaps heap")
