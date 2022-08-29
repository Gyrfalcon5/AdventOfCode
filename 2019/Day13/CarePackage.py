import Intputer
import copy
import random
import time
import os # To make a prettier display lol

def update_play_field(play_field, updates):

    for idx in range(0, len(updates), 3):

        location = (updates[idx], updates[idx+1])
        item = updates[idx+2]

        play_field[location] = item

    return play_field

def count_blocks(play_field):

    num_blocks = 0
    for key, value in play_field.items():
        if value == 2:
            num_blocks += 1

    return num_blocks

def update_display(display, play_field):

    for idx in range(len(display)):
        for jdx in range(len(display[0])):

            display[idx][jdx] = play_field[(jdx, idx)]

def show_display(display):

    for idx in range(len(display)):
        for jdx in range(len(display[0])):

            if display[idx][jdx] == 0:
                print(" ", end='')
            elif display[idx][jdx] == 1:
                print("W", end='')
            elif display[idx][jdx] == 2:
                print("B", end='')
            elif display[idx][jdx] == 3:
                print("~", end='')
            elif display[idx][jdx] == 4:
                print("o", end='')

        print("")

input_file = "PuzzleInput.txt"

instructions = Intputer.load_instructions(input_file)

play_field = {}

arcade_computer = Intputer.Intputer(copy.copy(instructions))

arcade_computer.process_instructions()

play_field = update_play_field(play_field, arcade_computer.output_buffer)

num_blocks = count_blocks(play_field)

print(num_blocks)

initial_blocks = num_blocks

instructions[0] = 2 # Gotta put in those quarters!

score = 0

play_field = {}

arcade_computer = Intputer.Intputer(copy.copy(instructions))

arcade_computer.process_instructions()

play_field = update_play_field(play_field, arcade_computer.output_buffer)

# Have to fudge these over one for some reason
x_max = max([key[0] for key in play_field.keys()]) + 1
y_max = max([key[1] for key in play_field.keys()]) + 1

display = [[0 for i in range(x_max)] for j in range(y_max)]

update_display(display, play_field)

num_blocks = count_blocks(play_field)

while num_blocks != 0:

    arcade_computer.clear_output_buffer()
    os.system('clear')
    show_display(display)

    paddle_x = 0
    ball_x = 0

    for keys, items in play_field.items():
        if items == 4:
            ball_x = keys[0]
        elif items == 3:
            paddle_x = keys[0]

        if ball_x and paddle_x:
            break

    user_input = 0

    if ball_x < paddle_x:
        user_input = -1
    elif ball_x > paddle_x:
        user_input = 1

    arcade_computer.process_instructions(user_input)

    play_field = update_play_field(play_field, arcade_computer.output_buffer)

    update_display(display, play_field)

    num_blocks = count_blocks(play_field)

    if arcade_computer.isHalted:
        print("GAME OVER")
        break

    time.sleep(0.01)

score = play_field[(-1, 0)]
print(initial_blocks - num_blocks)

print(score)
