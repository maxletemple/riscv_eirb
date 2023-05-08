ENTRY(_start)

MEMORY
{
    rom (rx ): ORIGIN = 0x000, LENGTH = 1024
    ram (rw): ORIGIN = 0x400, LENGTH = 1024
}

SECTIONS
{
    .text : {
        /*
            entry point is expected to be the first function here
            --> we are assuming there's only a single function in the .text.boot segment and by convention that is "_start"

            KEEP ensures that "_start" is kept here, even if there are no references to it
        */
        KEEP(*(.text.boot))

        /*
            all other code follows
        */
        *(.text*)
    } > rom

    .rodata : { *(.rodata*) } > rom

    .bss : { *(.bss*) } > ram
}
