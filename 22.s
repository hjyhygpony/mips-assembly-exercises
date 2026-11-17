.data
A_ptr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
B_ptr: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.text
main:
    daddi r1, r0, A_ptr  # r1 = A 数组起始地址
    daddi r2, r0, B_ptr  # r2 = B 数组起始地址
    daddi r3, r0, 10     # r3 = 循环次数 N = 10

Loop_Optimized:
    # L1: 读取 A[i]
    ld    r4, 0(r1)      # r4 = A[i]
    
    # U1: 调度填补 L1-L2 的延迟槽
    daddi r1, r1, 8      # r1 += 8 (A ptr update)
    
    # L2: 读取 B[i]
    ld    r5, 0(r2)      # r5 = B[i]
    
    # U2/C1: 调度填补 L2-A1 的延迟槽
    daddi r2, r2, 8      # r2 += 8 (B ptr update)
    daddi r3, r3, -1     # r3-- (Loop count update)
    
    # A1: 加法 (此时 L1/L2 拿到的数据 r4, r5 应该已经定向到 EX 级，无暂停)
    daddu r6, r4, r5     # r6 = r4 + r5
    
    # S1: 存储 (注意：r1 已经被更新，我们需要使用新的地址 r1 减去 8，来存储到正确的 A[i] 位置)
    sd    r6, -8(r1)     # A[i] = r6 (存储到 r1 之前的位置)
    
    # B1: 分支
    bnez  r3, Loop_Optimized
    halt