## Baking Rasberry Pi OS
### The OK0X series

The vital part, the ACT is now wired to the GPIO 47, and it's enabled by a 1,
not 0 written on the tutorial.

There are 54 pins on the Rasberry Pi, and there are few bytes in charge of the
functions of those pins, that is the function controller. Anyway, the
controller has 24 bytes in all, each 4 bytes(32 bits) is conressponding to at
most 10 pins.

### Some instructions
There is a some difference between `mov` and `ldr` when we assign constant to a
register. The former could only deal with those constant that only have 1s in
their first 8 leading bits, e.g. 0x12000000, 0x00120000, 0x00001200,
0x00000012. But there is no such restriction for `ldr reg, #const`
handle those constants. If you see the list files, you'll find that the
assembler will first put these constant in memory and then use `ldr reg,
[adr]`. However, it's somehow slower.

Also there is no `rol reg, n` for armv6, but you can simpy use `ror reg, 32-n`,
same thing.

### The Screen0X series
It's `.align 12` instead of `.align 4` in the `framebuffer.s`.
