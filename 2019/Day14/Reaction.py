class Reaction(object):

    def __init__(self, output, inputs):
        self.output_id = output[1]
        self.output_num = int(output[0])

        self.input_ids = []
        self.input_nums = []

        for input in inputs:
            self.input_ids.append(input[1])
            self.input_nums.append(int(input[0]))
