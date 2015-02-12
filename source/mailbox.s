        .globl GetMailboxBase
GetMailboxBase:
        ldr r0, =0x2000B880
        mov pc, lr


/* r0: value to write the lowest 4 bits should be 0
 * r1: mailbox number
 */
        .globl MailboxWrite
MailboxWrite:
        /* check */
        tst r0, #0b1111
        movne pc, lr
        cmp r1, #15
        movhi pc, lr

        /* retrieve the base address */
        channel .req r1
        value .req r2
        mov value, r0
        push {lr}
        bl GetMailboxBase
        mailbox .req r0

        /* read status and check */
wait1$:
        status  .req r3
        ldr status, [mailbox, #0x18]
        tst status, #0x80000000
        .unreq status
        bne wait1$

        /* concatenate the value and channel number */
        orr value, channel
        str value, [mailbox, #0x20]

        .unreq value
        .unreq channel
        pop {pc}

/* r0: value to write the lowest 4 bits should be 0
 * r1: mailbox number
 */
        .globl MailboxRead
MailboxRead:
        /* check */
        cmp r0, #15
        movhi pc, lr

        /* retrieve the base address */
        channel .req r1
        mov channel, r0
        push {lr}
        bl GetMailboxBase
        mailbox .req r0

        /* read STATUS and check*/
rightmail$:
wait2$:
        status .req r2
        ldr status, [mailbox, #0x18]
        tst status, #0x40000000
        bne wait2$
        .unreq status

        /* read */
        value .req r2
        ldr value, [mailbox, #0]

        /* confirm the mailbox */
        inchan .req r3
        and inchan, value, #0b1111
        teq inchan, channel
        bne rightmail$
        .unreq inchan
        .unreq channel
        .unreq mailbox

        and r0, value, #0xfffffff0
        .unreq value
        pop {pc}
