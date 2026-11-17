.data
a: .space 48
b: .word 1,2,3,4,5,6
c: .word 7,8,9,10,11,12

.text
daddi r1, r0, a
daddi r2, r0, b
daddi r3, r0, c
daddi r4, r0, 6

loop:
    lw r5, 0(r1)
    lw r6, 0(r2)
    lw r7, 0(r3)
    daddu r8, r5, r6
    daddu r9, r8, r7
    sw r9, 0(r1)
    daddi r1, r1, 4
    daddi r2, r2, 4
    daddi r3, r3, 4
    daddi r4, r4, -1
    bnez r4, loop

end:
    halt