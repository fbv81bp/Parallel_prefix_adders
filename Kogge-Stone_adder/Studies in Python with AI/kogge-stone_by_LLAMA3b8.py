def kogge_stone_adder(a, b):
    """
    Returns the result of adding two 16-bit integers using the Kogge-Stone adder.

    :param a: The first 16-bit integer.
    :param b: The second 16-bit integer.
    :return: A tuple containing the sum and carry bits as 16-bit integers.
    """
    # Initialize the result and carry bits
    result = [0] * 16
    carry = 0

    # Iterate through the bits of the input numbers
    for i in range(15, -1, -1):
        # Calculate the sum of the current bits and the previous carry
        sum_bit = (a[i] ^ b[i]) ^ carry
        # Update the result bit
        result[15-i] = sum_bit
        # Update the carry bit
        if a[i] & b[i]:
            carry = 1
        elif sum_bit:
            carry = 1

    return list(result + [carry])
    
def int_to_bin_array(x, bits=32):
    return [(x >> i) & 1 for i in range(bits)][::-1]


# Convert binary arrays to integers
def bin_array_to_int(bin_array):
    return sum(val << (len(bin_array) - 1 - idx) for idx, val in enumerate(bin_array))

print(bin_array_to_int(kogge_stone_adder(int_to_bin_array(5432), int_to_bin_array(6789))), 5432 + 6789)