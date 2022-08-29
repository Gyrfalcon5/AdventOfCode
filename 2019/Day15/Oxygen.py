import Intputer
import RepairBot
import copy

input_file = "PuzzleInput.txt"
instructions = Intputer.load_instructions(input_file)
repair_bot = RepairBot.RepairBot(copy.copy(instructions))

repair_bot.find_ox_sys()
length = repair_bot.path_to_ox()
print(length)
time = repair_bot.ox_time()
print(time)
