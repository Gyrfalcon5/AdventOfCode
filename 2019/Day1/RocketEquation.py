import math

def calc_fuel(mass):
    return math.floor(mass / 3) - 2

def calc_recursive_fuel(mass):
    fuel = calc_fuel(mass)

    if calc_fuel(fuel) > 0:
        return fuel + calc_recursive_fuel(fuel)
    else:
        return fuel

input_file = "RocketEquationInput.txt"

with open(input_file, "r") as fid:
    data = fid.readlines()

for i in range(len(data)):
    data[i] = int(data[i].strip())

output = []
recursive_output = []

for mass in data:
    output.append(calc_fuel(mass))
    recursive_output.append(calc_recursive_fuel(mass))

print(sum(output))
print(sum(recursive_output))
