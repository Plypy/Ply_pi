        .section .data
        .align 2
SeedAddress:
        .int 0

        .section .text

        /* set the seed of Random */
        .globl SetSeed
SetSeed:
        ldr r1, =SeedAddress
        str r0, [r1]
        mov pc, lr

        /* generate a random 32bit int */
        .globl Random
Random:
        ldr r2, =SeedAddress
        ldr r0, [r2]
        xnm .req r0
        a .req r1

        mov a, #0xef00
        mul a, xnm
        mul a, xnm
        add a, xnm
        add r0, a, #73
        str r0, [r2]

        .unreq xnm
        .unreq a
        mov pc, lr
