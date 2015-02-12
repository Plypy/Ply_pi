        .section .data
        .align 12
        .globl FrameBufferInfo
FrameBufferInfo:
        .int 1024 /* #0 Physical Width */
        .int 768 /* #4 Physical Height */
        .int 1024 /* #8 Virtual Width */
        .int 768 /* #12 Virtual Height */
        .int 0 /* #16 GPU - Pitch */
        .int 16 /* #20 Bit Depth */
        .int 0 /* #24 X */
        .int 0 /* #28 Y */
        .int 0 /* #32 GPU - Pointer */
        .int 0 /* #36 GPU - Size */

        .section .text
        .globl InitialiseFrameBuffer
InitialiseFrameBuffer:
        /* check */
        width .req r0
        height .req r1
        bitDepth .req r2
        cmp width, #4096
        cmpls height, #4096
        cmpls bitDepth, #32
        result .req r0
        movhi result, #0
        movhi pc, lr

        /* store all the values in place */
        push {r4, lr}
        fbInfoAddr .req r4
        ldr fbInfoAddr, =FrameBufferInfo
        str width, [fbInfoAddr, #0]
        str height, [fbInfoAddr, #4]
        str width, [fbInfoAddr, #8]
        str height, [fbInfoAddr, #12]
        str bitDepth, [fbInfoAddr, #20]
        .unreq width
        .unreq height
        .unreq bitDepth

        /* write to the mailbox */
        mov r0, fbInfoAddr
        add r0, #0x40000000
        mov r1, #1
        bl MailboxWrite

        /* read the result */
        mov r0, #1
        bl MailboxRead

        /* test the result code, 0 success*/
        teq result, #0
        movne result, #0
        popne {r4, pc}

        mov result, fbInfoAddr
        pop {r4, pc}
        .unreq result
        .unreq fbInfoAddr
