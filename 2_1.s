## 版本 A: 原始代码 (性能基准)
.data
    A:   .word 10, 5, 25, 15
    B:   .word 2, 6, 3, 4
    C:   .space 32  # 4 * 8 = 32 bytes
    
.text
main:
    daddi r1, r0, 0    # r1: 数组偏移地址 (i * 8)
    daddi r2, r0, 4    # r2: 循环次数 N = 4

Loop_Original:
    # 读 A[i]
    ld    r3, A(r1)      # r3 = A[i]
    # 读 B[i]
    ld    r4, B(r1)      # r4 = B[i]
    # 乘法 (RAW: 依赖 r3, r4)
    dmul  r5, r3, r4     # r5 = r3 * r4
    # 存储 (RAW: 依赖 r5)
    sd    r5, C(r1)      # C[i] = r5
    # 更新地址
    daddi r1, r1, 8      # r1 += 8 (推进 8 字节)
    # 更新循环计数
    daddi r2, r2, -1     # r2--
    # 分支
    bnez  r2, Loop_Original # Loop control
    
halt