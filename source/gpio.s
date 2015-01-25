.globl GetGpioAddress
GetGpioAddress:
    ldr r0,=0x20200000
    mov pc,lr

.globl SetGpioFunction
SetGpioFunction:
    cmp r0,#53
    cmpls r1,#7
    movhi pc,lr

    push {lr}           /* protect the original lr */
    mov r2,r0
    
    bl GetGpioAddress

    functionLoop$:
        cmp r2,#9
        subhi r2,#10
        addhi r0,#4
        bhi functionLoop$

    add r2, r2,lsl #1       /* r2 <- r2*3 */
    lsl r1,r2

    /* make a mask */
    mov r3,#7
    lsl r3,r2
    mvn r3,r3               /* bitwise not */

    /* preseve the old bits */
    ldr r2,[r0]
    and r2,r3
    orr r1, r2

    str r1, [r0]
    pop {pc}


.globl SetGpio
SetGpio:
    pinNum .req r0
    pinVal .req r1

    cmp pinNum, #53
    movhi pc,lr
    push {lr}
    mov r2, pinNum
    .unreq pinNum
    pinNum .req r2
    bl GetGpioAddress
    gpioAddr .req r0

    pinBank .req r3
    lsr pinBank, pinNum,#5    /* check whether the pinNum is above 32*/
    lsl pinBank, #2
    add gpioAddr, pinBank
    .unreq pinBank

    and pinNum, #31           /*  pinNum := pinNum MOD 32 */
    setBit .req r3
    mov setBit, #1
    lsl setBit, pinNum
    .unreq pinNum

    teq pinVal, #0
    .unreq pinVal
    streq setBit, [gpioAddr, #40]
    strne setBit, [gpioAddr, #28]
    .unreq setBit
    .unreq gpioAddr
    pop {pc}

