.data
A_ptr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
B_ptr: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.text
main:
    daddi r1, r0, A_ptr  # r1 = A 数组起始地址
    daddi r2, r0, B_ptr  # r2 = B 数组起始地址
    daddi r3, r0, 10     # r3 = 循环次数 N = 10

Loop_Original:
    # ---------------- 瓶颈区 ----------------
    ld    r4, 0(r1)      # L1: r4 = A[i]
    ld    r5, 0(r2)      # L2: r5 = B[i]
    
    daddu r6, r4, r5     # A1: r6 = r4 + r5  <-- 严重 Load-Use 暂停（等待 L1/L2 结果）
    
    sd    r6, 0(r1)      # S1: A[i] = r6     <-- 可能会有 ALU-Store 暂停
    # ----------------------------------------
    
    daddi r1, r1, 8      # U1: r1 += 8 (Update A ptr)
    daddi r2, r2, 8      # U2: r2 += 8 (Update B ptr)
    
    daddi r3, r3, -1     # C1: r3--
    bnez  r3, Loop_Original # B1: Branch
    halt