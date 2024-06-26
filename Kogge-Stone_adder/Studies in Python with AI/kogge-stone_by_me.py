def kogge_stone_adder(A, B, n):

    # Initialize arrays
    G = [0] * n  # Generate
    P = [0] * n  # Propagate
    C = [0] * (n + 1)  # Carry

    # Step 1: Calculate initial generate and propagate
    for i in range(n):
        G[i] = A[i] & B[i]
        P[i] = A[i] ^ B[i]

    # Step 2: Parallel prefix computation (Kogge-Stone)
    for d in range(n.bit_length() - 1):  # number of stages
        for i in range(n - 2**d):
            G[i + 2**d] = G[i + 2**d] | (P[i + 2**d] & G[i])
            P[i + 2**d] =                P[i + 2**d] & P[i]

    # Step 3: Calculate the carries
    for i in range(n):
        C[i + 1] = G[i] 

    # Step 4: Calculate the sum
    S = [0] * (n + 1)
    for i in range(n):
        S[i] =  A[i] ^ B[i] ^ C[i]
    S[n] = C[n]
    
    return S

# Convert integers to 32-bit binary arrays
def int_to_bin_array(x, n):
    return [(x >> i) & 1 for i in range(n)] ## little endian


# Convert binary arrays to integers
def bin_array_to_int(bin_array):
    return sum(val << idx for idx, val in enumerate(bin_array))

#test_passed! print(hex(bin_array_to_int(int_to_bin_array(0x65434567,32))))

# Example usage
A = int_to_bin_array(0xf0ffff1, 32)
B = int_to_bin_array(0xf1ffff0, 32)
result = kogge_stone_adder(A, B, len(A))
result_int = bin_array_to_int(result)

print(hex(result_int))
print(hex(0xf0ffff1 + 0xf1ffff0))

# testing for some numbers

for i in range(0x45645324, 0x45645324 + 100, 12):
    for j in range(0xfedfadbc, 0xfedfadbc + 100, 11):
        if (i + j) != bin_array_to_int(kogge_stone_adder(int_to_bin_array(i, 32),int_to_bin_array(j, 32), 32)):
            print(hex(i))
            print(hex(j))
            print(hex(i+j))
            print(hex(bin_array_to_int(kogge_stone_adder(int_to_bin_array(i, 32),int_to_bin_array(j, 32), 32))))
            print()
print("the end")