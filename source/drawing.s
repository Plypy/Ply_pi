        .section .data
        .align 1
foreColour:
        .hword 0xFFFF

        .align 2
graphicsAddress:
        .int 2

        .section .text
        .globl SetForeColour
SetForeColour:
        /* we use 16 bit high colour system */
        cmp r0, #0x10000
        movhs pc, lr
        ldr r1, =foreColour
        strh r0, [r1]
        mov pc, lr

        .globl SetGraphicsAddress
SetGraphicsAddress:
        ldr r1, =graphicsAddress
        str r0, [r1]
        mov pc, lr

        .globl DrawPixel
DrawPixel:
        px .req r0
        py .req r1
        addr .req r2
        ldr addr, =graphicsAddress
        ldr addr, [addr]

        /* check y */
        height .req r3
        mov height, [addr, #4]
        cmp py, height
        movhs pc, lr
        .unreq height

        /* check x */
        width .req r3
        mov width, [addr, #0]
        cmp px, width
        movhs pc, lr

        /* calculate the offset of the pixel's address */
        ldr addr, [addr, #32]
        mla px, y, width, px
        add addr, px
        .unreq px
        .unreq py
        .unreq width

        /* get the colour */
        fore .req r0
        ldr fore, =foreColour
        ldrh fore, [fore]

        /* store the colour into address */
        strh fore, [addr]
        .unreq fore
        .unreq addr
        mov pc, lr
