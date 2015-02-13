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
        ldr height, [addr, #4]
        cmp py, height
        movhs pc, lr
        .unreq height

        /* check x */
        width .req r3
        ldr width, [addr, #0]
        cmp px, width
        movhs pc, lr

        /* calculate the offset of the pixel's address */
        ldr addr, [addr, #32]
        mla px, py, width, px
        add addr, px, lsl #1
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

        /* Draw a line between {x0,y0}, {x1,y1} */
        .globl DrawLine
DrawLine:
        push {r4, r5, r6, r7, r8, r9, r10, r11, r12, lr}
        x0 .req r4
        y0 .req r5
        x1 .req r6
        y1 .req r7
        dx .req r8
        dyn .req r9
        sx .req r10
        sy .req r11
        err .req r12

        mov x0, r0
        mov y0, r1
        mov x1, r2
        mov y1, r3

        cmp x1, x0
        subgt dx, x1, x0
        movgt sx, #1
        suble dx, x0, x1
        movle sx, #-1

        cmp y1, y0
        subgt dyn, y0, y1
        movgt sy, #1
        suble dyn, y1, y0
        movle sy, #-1

        add err, dx, dyn
        add x1, sx
        add y1, sy

loop$:
        teq x0, x1
        teqne y0, y1
        beq end$

        mov r0, x0
        mov r1, y0
        bl DrawPixel

        cmp dyn, err, lsl #1
        addle x0, sx
        addle err, dyn

        cmp dx, err, lsl #1
        addge y0, sy
        addge err, dx

        b loop$
end$:
        .unreq x0
        .unreq y0
        .unreq x1
        .unreq y1
        .unreq dx
        .unreq dyn
        .unreq sx
        .unreq sy
        .unreq err
        pop {r4, r5, r6, r7, r8, r9, r10, r11, r12, pc}
