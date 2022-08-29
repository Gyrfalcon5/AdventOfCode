import copy
from Intputer import Intputer
from PaintBot import PaintBot

input_file = "PuzzleInput.txt"

with open(input_file, 'r') as fid:
    data = fid.readline()

instructions = data.strip().split(',')

for idx in range(len(instructions)):
    instructions[idx] = int(instructions[idx])

robot_computer = Intputer(copy.copy(instructions))

painter_robot = PaintBot(first_color = 0)

while not robot_computer.isHalted:

    current_paint = painter_robot.read_current_tile()

    robot_computer.process_instructions(current_paint)

    needed_color = robot_computer.output_buffer[-2]
    needed_turn = robot_computer.output_buffer[-1]

    painter_robot.paint(needed_color)
    painter_robot.move(needed_turn)

print(len(painter_robot.map))

painter_robot.show_painting()
