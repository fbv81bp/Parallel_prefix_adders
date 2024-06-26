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
    for i in range(1, n):
        C[i] = G[i - 1]
    C[n] = G[n - 1]

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
    return sum(val << (len(bin_array) - 1 - idx) for idx, val in enumerate(bin_array))


# Example usage
A = int_to_bin_array(0xffabcdff)
B = int_to_bin_array(0xffefdaff)
result = kogge_stone_adder(A, B)
result_int = bin_array_to_int(result)

print(result_int)
print(0xffabcdff + 0xffefdaff)
