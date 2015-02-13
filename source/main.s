        .section .init
        .globl _start
_start:

        b main

        .section .text

main:

/* init */
        mov sp, #0x8000

        mov r0, #47
        mov r1, #1
        bl  SetGpioFunction

        mov r0, #1024
        mov r1, #768
        mov r2, #16
        bl InitialiseFrameBuffer

        teq r0, #0
        bne noError$

        mov r0, #47
        mov r1, #1
        bl SetGpio

error$:
        b error$

noError$:
        /* init */
        bl SetGraphicsAddress

        x0 .req r4
        y0 .req r5
        x1 .req r6
        y1 .req r7
        colour .req r8
        tmp .req r9

        mov x0, #0
        mov y0, #0
        mov colour, #0
        mov tmp, #1

        mov r0, #0
        bl SetSeed


start$:
        mov r0, colour
        bl SetForeColour

        bl Random
        lsr r0, #22
        mov y1, r0
        cmp y1, #768
        bhs start$

        bl Random
        lsr r0, #22
        mov x1, r0

        mov r0, x0
        mov r1, y0
        mov r2, x1
        mov r3, y1
        bl DrawLine

        mov x0, x1
        mov y0, y1

        add colour, #1
        cmp colour, #0x10000
        movhs colour, #0

        /* set the led */
        mov r0, #47
        mov r1, tmp
        mov r3, #1
        sub tmp, r3, tmp
        bl SetGpio

        ldr r0, =50000
        bl Wait

        b start$
        .unreq x0
        .unreq y0
        .unreq x1
        .unreq y1
        .unreq colour
        .unreq tmp
        /*
render$:

        mov r0, lastRand
        bl Random
        mov y1, r0
        ldr tmp, =0x3ff
        and y1, tmp
        ldr tmp, =0x2ff
        cmp y1, tmp
        bhi render$


        bl Random
        mov x1, r0
        ldr tmp, =0x3ff
        and x1, tmp
        mov lastRand, r0

        mov r0, colour
        bl SetForeColour

        mov r0, x0
        mov r1, y0
        mov r2, x1
        mov r3, y1
        bl DrawLine


        mov x0, x1
        mov y0, y1
        add colour, #1
        ldr tmp, =0xffff
        and colour, tmp

        b render$
        */
