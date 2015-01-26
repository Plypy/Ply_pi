        .section .init
        .globl _start
_start:

        b main

        .section .text

main:

/* init */
        mov sp, #0x8000

        pinNum .req r0
        pinFunc .req r1
        mov pinNum, #47     @ set the GPIO47 as output mode
        mov pinFunc, #1
        bl SetGpioFunction
        .unreq pinNum
        .unreq pinFunc

/* load the pattern */
        ptrn .req r4
        ldr ptrn, =pattern
        ldr ptrn, [ptrn]
        mask .req r5
        mov mask, #1
loop$:

/* light on it */
        pinNum .req r0
        pinVal .req r1
/* get info bit */
        mov pinNum, #47
        mov pinVal, mask
        and pinVal, ptrn

        bl SetGpio

        ldr r0, =500000
        bl Wait

        ror mask, #31

b loop$;

/* data */
        .section .data
        .align 2
pattern:
        .int 0b11111111101010100010001000101010
