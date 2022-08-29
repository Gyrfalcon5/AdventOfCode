def get_operands(instructions, curr_instruction, pointer):

    for i in range(5 - len(curr_instruction)):
        curr_instruction.insert(0,0) # Pad to get the right number of 0s

    out_location = instructions[pointer + 3]

    if curr_instruction[1] == 0:
        op_2_location = instructions[pointer+2]
    else:
        op_2_location = pointer + 2

    if curr_instruction[2] == 0:
        op_1_location = instructions[pointer+1]
    else:
        op_1_location = pointer + 1

    op_1 = instructions[op_1_location]
    op_2 = instructions[op_2_location]

    return [op_1, op_2, out_location]

def get_io_operand(instructions, curr_instruction, pointer):

    for i in range(3 - len(curr_instruction)):
        curr_instruction.insert(0,0) # Pad to get the right number of 0s

    if curr_instruction[-1] == 4 and curr_instruction[0] == 1:
        op = pointer + 1
    else:
        op = instructions[pointer + 1]

    return op

def write_result(instructions, result, location):

    instructions[location] = result
    return instructions

def add_instruction(instructions, curr_instruction, pointer):
    operands = get_operands(instructions, curr_instruction, pointer)

    result = operands[0] + operands[1]
    return write_result(instructions, result, operands[2])

def mult_instruction(instructions, curr_instruction, pointer):
    operands = get_operands(instructions, curr_instruction, pointer)

    result = operands[0] * operands[1]
    return write_result(instructions, result, operands[2])

def output_instruction(instructions, curr_instruction, pointer):

    operand = get_io_operand(instructions, curr_instruction, pointer)

    print("Output is {}".format(instructions[operand]))

def input_instruction(instructions, curr_instruction, pointer):

    operand = get_io_operand(instructions, curr_instruction, pointer)

    user_input = int(input("Please enter input: "))

    return write_result(instructions, user_input, operand)

def jump_instruction(instructions, curr_instruction, pointer, jump_type):

    operands = get_operands(instructions, curr_instruction, pointer)

    if ((operands[0] and jump_type) or (not operands[0] and not jump_type)):
        return operands[1]
    else:
        return (pointer + 3)

def less_than_instruction(instructions, curr_instruction, pointer):

    operands = get_operands(instructions, curr_instruction, pointer)

    if operands[0] < operands[1]:
        return write_result(instructions, 1, operands[2])
    else:
        return write_result(instructions, 0, operands[2])

def equals_instruction(instructions, curr_instruction, pointer):

    operands = get_operands(instructions, curr_instruction, pointer)

    if operands[0] == operands[1]:
        return write_result(instructions, 1, operands[2])
    else:
        return write_result(instructions, 0, operands[2])

def process_instructions(instructions):

    pointer = 0

    while True:

        if pointer > (len(instructions) - 1):
            break
        elif instructions[pointer] == 99:
            break

        curr_instruction = [int(num) for num in str(instructions[pointer])]

        if curr_instruction[-1] == 1:
            instructions = add_instruction(instructions, curr_instruction, pointer)
            pointer += 4
        elif curr_instruction[-1] == 2:
            instructions = mult_instruction(instructions, curr_instruction, pointer)
            pointer += 4
        elif curr_instruction[-1] == 3:
            instructions = input_instruction(instructions, curr_instruction, pointer)
            pointer += 2
        elif curr_instruction[-1] == 4:
            output_instruction(instructions, curr_instruction, pointer)
            pointer += 2
        elif curr_instruction[-1] == 5:
            pointer = jump_instruction(instructions, curr_instruction, pointer, True)
        elif curr_instruction[-1] == 6:
            pointer = jump_instruction(instructions, curr_instruction, pointer, False)
        elif curr_instruction[-1] == 7:
            instructions = less_than_instruction(instructions, curr_instruction, pointer)
            pointer += 4
        elif curr_instruction[-1] == 8:
            instructions = equals_instruction(instructions, curr_instruction, pointer)
            pointer += 4

    print("PROGRAM TERMINATED")

    return instructions

input_file = "PuzzleInput.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')

for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

process_instructions(instructions)
