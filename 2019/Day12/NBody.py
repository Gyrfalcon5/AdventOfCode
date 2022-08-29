from Planet import Planet
import re
import copy
from functools import reduce


def create_planets(file_name):

    pattern = "<x=(.*), y=(.*), z=(.*)>"
    prog = re.compile(pattern)

    planets = []

    with open(file_name, 'r') as fid:
        raw_input = fid.readlines()

    for line in raw_input:
        result = prog.match(line)
        planet_position = []
        for idx in range(1,4):
            planet_position.append(int(result.group(idx)))

        planets.append(Planet(planet_position))

    return planets

# Least common multiple stuff that I only knew to use because I spoiled it for
# myself :(
def gcd(a, b):

    while b:
        a, b = b, a % b
    return a

def lcm(a, b):
    return a * b // gcd(a, b)

input_file = "PuzzleInput.txt"

planets = create_planets(input_file)

for time_step in range(1000):

    for idx in range(len(planets)):

        other_planets = [planet for planet in planets if planet != planets[idx]]
        planets[idx].update_velocity(other_planets)

    for idx in range(len(planets)):
        planets[idx].update_position()

total_energy = 0

for planet in planets:
    total_energy += planet.total_energy

print(total_energy)

planets = create_planets(input_file)

initial_states = copy.deepcopy(planets)

done = False
matches = [0 for i in range(len(planets[0].position))]
step = 0

while not done:

    for idx in range(len(planets)):

        other_planets = [planet for planet in planets if planet != planets[idx]]
        planets[idx].update_velocity(other_planets)

    for idx in range(len(planets)):
        planets[idx].update_position()

    step += 1

    for idx in range(len(planets[0].position)):

        if matches[idx]:
            continue

        match_found = True

        for jdx in range(len(planets)):

            if (planets[jdx].position[idx] != initial_states[jdx].position[idx]
                or planets[jdx].velocity[idx] != initial_states[jdx].velocity[idx]):
                match_found = False
                break

        if match_found:
            matches[idx] = step

    done = True
    for match in matches:
        if not match:
            done = False
            break

time_to_repeat = reduce(lcm, matches)
print(time_to_repeat)
