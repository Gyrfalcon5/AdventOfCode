class Intputer(object):

    def __init__(self, instructions, pointer=0, relative_base=0, output_block=False):

        self.instructions = instructions
        self.pointer = pointer
        self.relative_base = relative_base
        self.curr_instruction = [int(num) for num in str(self.instructions[self.pointer])]
        self.output_block = output_block
        self.output_buffer = []
        self.input_buffer = []
        self.block = False
        self.isHalted = False

    def get_operands(self):
        for i in range(5 - len(self.curr_instruction)):
            self.curr_instruction.insert(0,0) # Pad to get the right number of 0s

        if self.curr_instruction[0] == 0:
            out_location = self.instructions[self.pointer + 3]
        elif self.curr_instruction[0] == 2:
            out_location = self.instructions[self.pointer + 3] + self.relative_base
        else:
            raise ValueError("Incorrect mode for output operand!")

        if self.curr_instruction[1] == 0:
            op_2_location = self.instructions[self.pointer+2]
        elif self.curr_instruction[1] == 1:
            op_2_location = self.pointer + 2
        elif self.curr_instruction[1] == 2:
            op_2_location = self.instructions[self.pointer+2] + self.relative_base
        else:
            raise ValueError("Incorrect mode for second operand!")

        if self.curr_instruction[2] == 0:
            op_1_location = self.instructions[self.pointer+1]
        elif self.curr_instruction[2] == 1:
            op_1_location = self.pointer + 1
        elif self.curr_instruction[2] == 2:
            op_1_location = self.instructions[self.pointer+1] + self.relative_base
        else:
            raise ValueError("Incorrect mode for first operand!")

        # We handle big memory on write, so this covers it on read
        try:
            op_1 = self.instructions[op_1_location]
        except IndexError:
            op_1 = 0

        try:
            op_2 = self.instructions[op_2_location]
        except IndexError:
            op_2 = 0

        return [op_1, op_2, out_location]

    def get_io_operand(self):

        for i in range(3 - len(self.curr_instruction)):
            self.curr_instruction.insert(0,0) # Pad to get the right number of 0s

        if self.curr_instruction[0] == 0:
            op = self.instructions[self.pointer + 1]
        elif self.curr_instruction[0] == 1:
            op = self.pointer + 1
        elif self.curr_instruction[0] == 2:
            op = self.instructions[self.pointer + 1] + self.relative_base
        else:
            raise ValueError("Incorrect mode for I/O operand!")

        return op

    def write_result(self, result, location):

        # Extend memory if needed
        try:
            self.instructions[location] = result
        except IndexError:
            self.instructions.extend([0] * ((location + 1) - len(self.instructions)))
            self.instructions[location] = result

    def add_instruction(self):
        operands = self.get_operands()

        result = operands[0] + operands[1]
        self.write_result(result, operands[2])
        self.pointer += 4

    def mult_instruction(self):
        operands = self.get_operands()

        result = operands[0] * operands[1]
        self.write_result(result, operands[2])
        self.pointer += 4

    def output_instruction(self):

        operand = self.get_io_operand()

        self.output_buffer.append(self.instructions[operand])

        if self.output_block:
            self.block = True

        self.pointer += 2

    def input_instruction(self):

        # Check for no input, and block if input is empty
        if len(self.input_buffer) < 1:
            self.block = True
            return

        operand = self.get_io_operand()

        self.write_result(self.input_buffer.pop(), operand)
        self.pointer += 2

    def jump_instruction(self, jump_type):

        operands = self.get_operands()

        if ((operands[0] and jump_type) or (not operands[0] and not jump_type)):
            self.pointer = operands[1]
        else:
            self.pointer += 3

    def less_than_instruction(self):

        operands = self.get_operands()

        if operands[0] < operands[1]:
            self.write_result(1, operands[2])
        else:
            self.write_result(0, operands[2])

        self.pointer += 4

    def equals_instruction(self):

        operands = self.get_operands()

        if operands[0] == operands[1]:
            self.write_result(1, operands[2])
        else:
            self.write_result(0, operands[2])

        self.pointer += 4

    def modify_base_instruction(self):

        operand = self.get_io_operand()

        self.relative_base += self.instructions[operand]

        self.pointer += 2

    def process_instructions(self, inputs=None):

        if inputs is not None:
            try:
                for item in inputs:
                    self.input_buffer.insert(0, item)
            except TypeError: # Catch singular inputs here
                self.input_buffer.insert(0,inputs)
        else:
            inputs = []

        while True:

            if self.pointer > (len(self.instructions) - 1):
                break
            elif self.instructions[self.pointer] == 99:
                self.isHalted = True
                break

            self.curr_instruction = [int(num) for num in str(self.instructions[self.pointer])]

            if self.curr_instruction[-1] == 1:
                self.add_instruction()
            elif self.curr_instruction[-1] == 2:
                self.mult_instruction()
            elif self.curr_instruction[-1] == 3:
                self.input_instruction()
            elif self.curr_instruction[-1] == 4:
                self.output_instruction()
            elif self.curr_instruction[-1] == 5:
                self.jump_instruction(True)
            elif self.curr_instruction[-1] == 6:
                self.jump_instruction(False)
            elif self.curr_instruction[-1] == 7:
                self.less_than_instruction()
            elif self.curr_instruction[-1] == 8:
                self.equals_instruction()
            elif self.curr_instruction[-1] == 9:
                self.modify_base_instruction()

            if self.block:
                self.block = False
                return

    def clear_output_buffer(self):
        self.output_buffer = []

def load_instructions(input_file):

    with open(input_file, 'r') as fid:
        data = fid.readline()

    instructions = data.strip().split(',')

    for idx in range(len(instructions)):
        instructions[idx] = int(instructions[idx])

    return instructions
