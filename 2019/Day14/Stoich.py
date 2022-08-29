import Reaction
import math

def parse_reactions(file_name):

    with open(file_name, 'r') as fid:
        data = fid.readlines()

    reactions = {}

    for line in data:
        inputs = line.split("=>")[0].strip()
        outputs = line.split("=>")[1].strip()
        inputs = inputs.split(",")
        inputs = [x.strip() for x in inputs]
        inputs = [x.split(" ") for x in inputs]
        outputs = outputs.split(" ")
        new_reaction = Reaction.Reaction(outputs, inputs)
        reactions[new_reaction.output_id] = new_reaction

    return reactions

def produce_compound(reactions, output_id, num_needed):
    current_reaction = reactions[output_id]
    ore_total = 0

    try:
        current_extra = produce_compound.extra[current_reaction.output_id]
    except KeyError:
        produce_compound.extra[current_reaction.output_id] = 0
        current_extra = 0

    if num_needed <= current_extra:
        produce_compound.extra[current_reaction.output_id] -= num_needed
        return 0
    elif num_needed > current_extra:
        num_needed -= current_extra
        produce_compound.extra[current_reaction.output_id] = 0

    num_reactions = math.ceil(num_needed / current_reaction.output_num)
    produce_compound.extra[current_reaction.output_id] = num_reactions * current_reaction.output_num - num_needed


    for idx in range(len(current_reaction.input_ids)):
        if current_reaction.input_ids[idx] == 'ORE':
            ore_total += num_reactions*current_reaction.input_nums[idx]
        else:
            ore_total += produce_compound(reactions, current_reaction.input_ids[idx], num_reactions*current_reaction.input_nums[idx])

    return ore_total



input_file = "PuzzleInput.txt"
test_files = ["Test1_1.txt", "Test1_2.txt", "Test1_3.txt", "Test1_4.txt", "Test1_5.txt"]
test_outputs = [31, 165, 13312, 180697, 2210736]

for idx in range(len(test_files)):

    reactions = parse_reactions(test_files[idx])
    produce_compound.extra = {}
    ore = produce_compound(reactions, 'FUEL', 1)
    assert ore == test_outputs[idx]

reactions = parse_reactions(input_file)
produce_compound.extra = {}
ore = produce_compound(reactions, 'FUEL', 1)
print(ore)

needed_ore = 0
num_fuel = int(1e12) // ore

for i in range(5):
    produce_compound.extra = {}
    needed_ore = produce_compound(reactions, 'FUEL', num_fuel)
    num_fuel = math.floor((int(1e12) / needed_ore)*num_fuel)
    print(num_fuel)

while True:

    needed_ore_old = needed_ore
    produce_compound.extra = {}
    needed_ore = produce_compound(reactions, 'FUEL', num_fuel)
    print(needed_ore)

    if needed_ore > int(1e12) and needed_ore_old > int(1e12):
        num_fuel -= 1
        continue
    elif needed_ore > int(1e12) and needed_ore_old < int(1e12):
        num_fuel -= 1
        break
    elif needed_ore < int(1e12) and needed_ore_old > int(1e12):
        break
    elif needed_ore < int(1e12) and needed_ore_old < int(1e12):
        num_fuel += 1
        continue


print(num_fuel)
