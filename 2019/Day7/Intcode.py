import copy
import itertools

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

    #print("Output is {}".format(instructions[operand]))

    return instructions[operand]

def input_instruction(instructions, curr_instruction, pointer, user_input):

    operand = get_io_operand(instructions, curr_instruction, pointer)

    #print("User provided input is {}".format(user_input))

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

def process_instructions(instructions, inputs, pointer=0):

    output = None
    inputs = inputs[::-1]

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
            if len(inputs) < 1: # Block on empty input
                return output, instructions, pointer
            instructions = input_instruction(instructions, curr_instruction, pointer, inputs.pop())
            pointer += 2
        elif curr_instruction[-1] == 4:
            output = output_instruction(instructions, curr_instruction, pointer)
            pointer += 2
            return output, instructions, pointer
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

    #print("PROGRAM TERMINATED")

    return output, instructions, pointer


def amp_computers(instructions, amp_settings):

    amp_output = 0

    for setting in amp_settings:
        amp_output, __, __ = process_instructions(copy.copy(instructions), [setting, amp_output])

    return amp_output

def calc_max_output(instructions):

    final_outputs = []

    amp_settings = list(itertools.permutations([0,1,2,3,4]))

    for settings in amp_settings:
        final_outputs.append(amp_computers(instructions, settings))

    return max(final_outputs)

def feedback_computers(instructions, amp_settings):

    computer_states = []

    for i in range(5):
        computer_states.append([copy.copy(instructions), 0])

    exec_id = 0 # Keeps track of which computer can execute
    amp_output = 0

    # Initializes them with their settings and stuff
    for exec_id in range(5):

        _, \
        computer_states[exec_id][0], \
        computer_states[exec_id][1] = process_instructions(computer_states[exec_id][0],
                                      [amp_settings[exec_id]],
                                      computer_states[exec_id][1])

    exec_id = 0

    while True:

        amp_output, \
        computer_states[exec_id][0], \
        computer_states[exec_id][1] = process_instructions(computer_states[exec_id][0],
                                      [amp_output],
                                      computer_states[exec_id][1])

        if exec_id == 4 and amp_output is not None:
            final_amp_output = amp_output

        if computer_states[-1][0][computer_states[-1][1]] == 99:
            break
        else:
            exec_id += 1
            exec_id = exec_id % 5

    return final_amp_output

def calc_max_feedback(instructions):

    final_outputs = []

    amp_settings = list(itertools.permutations([5,6,7,8,9]))

    for settings in amp_settings:
        final_outputs.append(feedback_computers(instructions, settings))

    return max(final_outputs)


input_file = "PuzzleInput.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')

for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

max_output = calc_max_output(instructions)

print(max_output)


input_file = "Test2_2.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')

for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

max_output = calc_max_feedback(instructions)

print(max_output)
