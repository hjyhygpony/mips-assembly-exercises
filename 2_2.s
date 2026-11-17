## 版本 B: 优化代码 (展开 3 次, 共 4 个循环体, 寄存器换名, 指令调度)
.data
    # 数据和原始代码保持一致
    A:   .word 10, 5, 25, 15
    B:   .word 2, 6, 3, 4
    C:   .space 32  # 4 * 8 = 32 bytes
    
.text
main:
    daddi r1, r0, 0    # r1: 数组偏移地址 (i * 8)
    daddi r2, r0, 1    # r2: 新循环次数 N/4 = 1

Loop_Unrolled:
    
    # === 指令调度和寄存器换名 ===

    # Load 块 (L1-L8)
    ld    r3, 0(r1)      # L1: r3 = A[0]
    ld    r4, 0(r1)      # L2: r4 = B[0]
    
    ld    r6, 8(r1)      # L3: r6 = A[1]  (R.R.)
    ld    r7, 8(r1)      # L4: r7 = B[1]  (R.R.)
    
    ld    r9, 16(r1)     # L5: r9 = A[2]  (R.R.)
    ld    r10, 16(r1)    # L6: r10 = B[2] (R.R.)

    ld    r12, 24(r1)    # L7: r12 = A[3] (R.R.)
    ld    r13, 24(r1)    # L8: r13 = B[3] (R.R.)

    # Multiply 块 (M1-M4) 
    dmul  r5, r3, r4     # M1: r5 = A[0]*B[0]
    dmul  r8, r6, r7     # M2: r8 = A[1]*B[1] (R.R.)
    dmul  r11, r9, r10   # M3: r11 = A[2]*B[2] (R.R.)
    dmul  r14, r12, r13  # M4: r14 = A[3]*B[3] (R.R.)

    # Store/Loop Control 块 (S1-S4)
    sd    r5, 0(r1)      # S1: C[0] = r5
    
    daddi r1, r1, 32     # r1 += 32 (Address update)
    
    sd    r8, 8(r1)      # S2: C[1] = r8
    
    daddi r2, r2, -1     # r2-- (Loop count update)

    sd    r11, 16(r1)    # S3: C[2] = r11

    sd    r14, 24(r1)    # S4: C[3] = r14
    
    bnez  r2, Loop_Unrolled # Loop control
    
halt