import copy

def get_operands(instructions, pointer):
    op_1_location = instructions[pointer+1]
    op_2_location = instructions[pointer+2]
    out_location = instructions[pointer+3]

    op_1 = instructions[op_1_location]
    op_2 = instructions[op_2_location]

    return [op_1, op_2, out_location]

def write_result(instructions, result, location):

    instructions[location] = result
    return instructions

def add_instruction(instructions, pointer):
    operands = get_operands(instructions, pointer)

    result = operands[0] + operands[1]
    return write_result(instructions, result, operands[2])

def mult_instruction(instructions, pointer):
    operands = get_operands(instructions, pointer)

    result = operands[0] * operands[1]
    return write_result(instructions, result, operands[2])

def process_instructions(instructions):

    pointer = 0

    while True:

        if pointer > (len(instructions) - 1):
            break
        elif instructions[pointer] == 99:
            break
        elif instructions[pointer] == 1:
            instructions = add_instruction(instructions, pointer)
        elif instructions[pointer] == 2:
            instructions = mult_instruction(instructions, pointer)

        pointer += 4

    return instructions

input_file = "IntcodeInput.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')


for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

original_instructions = copy.deepcopy(instructions)

output = process_instructions(instructions)


print(output)

results = []

for noun in range(100):
    for verb in range(100):
        test_instructions = copy.deepcopy(original_instructions)
        test_instructions[1] = noun
        test_instructions[2] = verb
        output = process_instructions(test_instructions)

        if output[0] == 19690720:
            print(100 * noun + verb)
