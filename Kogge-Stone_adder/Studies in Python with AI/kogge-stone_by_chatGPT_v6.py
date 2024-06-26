def kogge_stone_adder(A, B):
    n = 32

    # Initialize arrays
    G = [0] * n  # Generate
    P = [0] * n  # Propagate
    C = [0] * (n + 1)  # Carry

    # Step 1: Calculate initial generate and propagate
    for i in range(n):
        G[i] = A[i] & B[i]
        P[i] = A[i] ^ B[i]

    # Step 2: Parallel prefix computation (Kogge-Stone)
    for d in range(n.bit_length()):  # number of stages
        shift = 1 << d
        for i in range(n):
            if i >= shift:
                g_prev = G[i - shift]
                p_prev = P[i - shift]
                g_curr = G[i]
                p_curr = P[i]
                G[i] = g_curr | (p_curr & g_prev)
                P[i] = p_curr & p_prev

    # Step 3: Calculate the carries
    C[0] = 0  # Initial carry is zero
    for i in range(n):
        if i == 0:
            C[i + 1] = G[i]  # First carry-out
        else:
            C[i + 1] = G[i] | (P[i] & C[i])

    # Step 4: Calculate the sum
    S = [0] * (n + 1)
    for i in range(n):
        S[i] = P[i] ^ C[i]
    S[n] = C[n]  # Overflow carry

    return S


# Convert integers to 32-bit binary arrays
def int_to_bin_array(x, bits=32):
    return [(x >> i) & 1 for i in range(bits)][::-1]


# Convert binary arrays to integers
def bin_array_to_int(bin_array):
    return sum(val << idx for idx, val in enumerate(reversed(bin_array)))


# Example usage
A = int_to_bin_array(0xff9b1df)
B = int_to_bin_array(0xfe9d1af)
result = kogge_stone_adder(A, B)
result_int = bin_array_to_int(result)

print(result_int)
print(0xff9b1df + 0xfe9d1af)
