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

loop$:

/* light on it */
pinNum .req r0
pinVal .req r1
mov pinNum, #47
mov pinVal, #1
bl SetGpio

decr .req r2
mov decr, #0x3F0000

wait1$:
    sub decr, #1
    cmp decr, #0
    bne wait1$

/* light off */
mov pinNum, #47
mov pinVal, #0
bl SetGpio

mov decr, #0x3F0000

wait2$:
    sub decr, #1
    cmp decr, #0
    bne wait2$

b loop$;
