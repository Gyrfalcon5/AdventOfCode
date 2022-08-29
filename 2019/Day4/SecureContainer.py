# Just reads in the data and gets it formatted right
def read_range(file_name):

    with open(file_name, 'r') as fid:
        code_range = fid.readline().strip().split('-')

    for idx in range(len(code_range)):
        code_range[idx] = int(code_range[idx])

    return code_range

# Does ths simple validation routine for part one
def validate_code(code):

    # Get our code as a list of integers
    code = [int(num) for num in str(code)]

    # Make sure they are strictly ascending
    for idx in range(len(code) - 1):
        if code[idx] > code[idx + 1]:
            return 0 # Code is invalid

    # Check if there are any repeats
    for idx in range(len(code) - 1):
        if code[idx] == code[idx + 1]:
            return 1 # Code is valid

    # If there's no repeats, the code is invalid
    return 0

# Does the more complex validation routine for part 2
def advanced_validate_code(code):

    # Get our code as a list of integers
    code = [int(num) for num in str(code)]

    # Make sure they are strictly ascending
    for idx in range(len(code) - 1):
        if code[idx] > code[idx + 1]:
            return 0 # Code is invalid

    # Check for repeats, not including 3+
    for idx in range(len(code) - 1):
        # If you arent right at the end and it isn't a 3 going forward
        if idx < len(code) - 2 and (code[idx] == code[idx + 1]
                                    and code[idx+1] != code[idx+2]):
            # If it's right at the beginning it can't have a 3 going backward
            if  idx == 0:
                return 1 # Code is valid
            # Otherwise check backward to be sure
            elif code[idx] != code[idx - 1]:
                return 1 # Code is valid
        # Check that if it's at the very end, there's no 3 going backward
        elif idx == (len(code) - 2) and code[idx] == code[idx + 1]:

            if idx >= 1 and code[idx] != code[idx - 1]:
                return 1 # Code is valid
    # If there's no repeats without 3+, then the code is invalid
    return 0

# Applies the simple validation function over a range defined in a file and sums
# up the number of valid codes
def validate_range(file_name):

    code_range = read_range(file_name)

    num_valid = 0
    for code in range(code_range[0], code_range[1] + 1):
        num_valid += validate_code(code)

    return num_valid

# Applies the advanced validation function over a range defined in a file and
# sums up the number of valid codes
def advanced_validate_range(file_name):

    code_range = read_range(file_name)

    num_valid = 0
    for code in range(code_range[0], code_range[1] + 1):
        num_valid += advanced_validate_code(code)

    return num_valid

input_file = "PuzzleInput.txt"

print(validate_range(input_file))

print(advanced_validate_range(input_file))
