import copy

def get_operands(instructions, curr_instruction, pointer, relative_base):

    for i in range(5 - len(curr_instruction)):
        curr_instruction.insert(0,0) # Pad to get the right number of 0s

    if curr_instruction[0] == 0:
        out_location = instructions[pointer + 3]
    elif curr_instruction[0] == 2:
        out_location = instructions[pointer + 3] + relative_base
    else:
        raise ValueError("Incorrect mode for output operand!")

    if curr_instruction[1] == 0:
        op_2_location = instructions[pointer+2]
    elif curr_instruction[1] == 1:
        op_2_location = pointer + 2
    elif curr_instruction[1] == 2:
        op_2_location = instructions[pointer+2] + relative_base
    else:
        raise ValueError("Incorrect mode for second operand!")

    if curr_instruction[2] == 0:
        op_1_location = instructions[pointer+1]
    elif curr_instruction[2] == 1:
        op_1_location = pointer + 1
    elif curr_instruction[2] == 2:
        op_1_location = instructions[pointer+1] + relative_base
    else:
        raise ValueError("Incorrect mode for first operand!")

    # We handle big memory on write, so this covers it on read
    try:
        op_1 = instructions[op_1_location]
    except IndexError:
        op_1 = 0

    try:
        op_2 = instructions[op_2_location]
    except IndexError:
        op_2 = 0

    return [op_1, op_2, out_location]

def get_io_operand(instructions, curr_instruction, pointer, relative_base):

    for i in range(3 - len(curr_instruction)):
        curr_instruction.insert(0,0) # Pad to get the right number of 0s

    if curr_instruction[0] == 0:
        op = instructions[pointer + 1]
    elif curr_instruction[0] == 1:
        op = pointer + 1
    elif curr_instruction[0] == 2:
        op = instructions[pointer + 1] + relative_base
    else:
        raise ValueError("Incorrect mode for I/O operand!")

    return op

def write_result(instructions, result, location):

    # Extend memory if needed
    try:
        instructions[location] = result
    except IndexError:
        instructions.extend([0] * ((location + 1) - len(instructions)))
        instructions[location] = result

    return instructions

def add_instruction(instructions, curr_instruction, pointer, relative_base):
    operands = get_operands(instructions, curr_instruction, pointer, relative_base)

    result = operands[0] + operands[1]
    return write_result(instructions, result, operands[2])

def mult_instruction(instructions, curr_instruction, pointer, relative_base):
    operands = get_operands(instructions, curr_instruction, pointer, relative_base)

    result = operands[0] * operands[1]
    return write_result(instructions, result, operands[2])

def output_instruction(instructions, curr_instruction, pointer, relative_base):

    operand = get_io_operand(instructions, curr_instruction, pointer, relative_base)

    return instructions[operand]

def input_instruction(instructions, curr_instruction, pointer, user_input, relative_base):

    operand = get_io_operand(instructions, curr_instruction, pointer, relative_base)

    return write_result(instructions, user_input, operand)

def jump_instruction(instructions, curr_instruction, pointer, jump_type, relative_base):

    operands = get_operands(instructions, curr_instruction, pointer, relative_base)

    if ((operands[0] and jump_type) or (not operands[0] and not jump_type)):
        return operands[1]
    else:
        return (pointer + 3)

def less_than_instruction(instructions, curr_instruction, pointer, relative_base):

    operands = get_operands(instructions, curr_instruction, pointer, relative_base)

    if operands[0] < operands[1]:
        return write_result(instructions, 1, operands[2])
    else:
        return write_result(instructions, 0, operands[2])

def equals_instruction(instructions, curr_instruction, pointer, relative_base):

    operands = get_operands(instructions, curr_instruction, pointer, relative_base)

    if operands[0] == operands[1]:
        return write_result(instructions, 1, operands[2])
    else:
        return write_result(instructions, 0, operands[2])

def modify_base_instruction(instructions, curr_instruction, pointer, relative_base):


    operand = get_io_operand(instructions, curr_instruction, pointer, relative_base)

    return relative_base + instructions[operand]

def process_instructions(instructions, inputs=None, pointer=0):

    output = []
    if inputs is None:
        inputs = []
    inputs = inputs[::-1]
    relative_base = 0

    while True:

        if pointer > (len(instructions) - 1):
            break
        elif instructions[pointer] == 99:
            break

        curr_instruction = [int(num) for num in str(instructions[pointer])]

        if curr_instruction[-1] == 1:
            instructions = add_instruction(instructions, curr_instruction, pointer, relative_base)
            pointer += 4
        elif curr_instruction[-1] == 2:
            instructions = mult_instruction(instructions, curr_instruction, pointer, relative_base)
            pointer += 4
        elif curr_instruction[-1] == 3:
            if len(inputs) < 1: # Block on empty input
                return output, instructions, pointer
            instructions = input_instruction(instructions, curr_instruction, pointer, inputs.pop(), relative_base)
            pointer += 2
        elif curr_instruction[-1] == 4:
            output.append(output_instruction(instructions, curr_instruction, pointer, relative_base))
            pointer += 2
        elif curr_instruction[-1] == 5:
            pointer = jump_instruction(instructions, curr_instruction, pointer, True, relative_base)
        elif curr_instruction[-1] == 6:
            pointer = jump_instruction(instructions, curr_instruction, pointer, False, relative_base)
        elif curr_instruction[-1] == 7:
            instructions = less_than_instruction(instructions, curr_instruction, pointer, relative_base)
            pointer += 4
        elif curr_instruction[-1] == 8:
            instructions = equals_instruction(instructions, curr_instruction, pointer, relative_base)
            pointer += 4
        elif curr_instruction[-1] == 9:
            relative_base = modify_base_instruction(instructions, curr_instruction, pointer, relative_base)
            pointer += 2

    #print("PROGRAM TERMINATED")

    return output, instructions, pointer, relative_base


input_file = "PuzzleInput.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')

for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

output, _, _, _ = process_instructions(copy.copy(instructions), [1])

print(output)

output, _, _, _ = process_instructions(copy.copy(instructions), [2])

print(output)
