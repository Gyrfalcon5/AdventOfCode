import math
import operator

def create_asteroid_map(file):

    with open(file, 'r') as fid:

        raw_data = fid.readlines()

    map = []

    # This could probably be a list comprehension but eh
    for line in raw_data:
        map_line = []
        for item in line:
            map_line.append(item == '#')
        map.append(map_line)

    return map

def find_max_asteroids(map):

    max_asteroids = 0
    station_location = None

    for idx in range(len(map)):
        for jdx in range(len(map[0])):

            # Skip checking blank squares
            if not map[idx][jdx]:
                continue

            blocked_slopes = []

            for kdx in range(len(map)):
                for ldx in range(len(map[0])):

                    # Skip checking blank squares, or against yourself
                    if not map[kdx][ldx]:
                        continue
                    elif kdx == idx and ldx == jdx:
                        continue

                    try:
                        slope = float(kdx - idx) / float(ldx - jdx)

                        if float(kdx - idx) >= 0 and float(ldx - jdx) > 0:
                            quadrant = 1
                        elif float(kdx - idx) >= 0 and float(ldx - jdx) < 0:
                            quadrant = 2
                        elif float(kdx - idx) <= 0 and float(ldx - jdx) > 0:
                            quadrant = 3
                        elif float(kdx - idx) <= 0 and float(ldx - jdx) < 0:
                            quadrant = 4

                    except ZeroDivisionError:
                        if float(kdx - idx) < 0:
                            slope = -1 * math.inf
                            quadrant = 2
                        else:
                            slope = math.inf
                            quadrant = 1

                    valid_spot = True

                    for blocked in blocked_slopes:
                        if (math.isclose(slope, blocked[0], rel_tol=1e-5)
                            and blocked[1] == quadrant):
                            valid_spot = False
                            break

                    if valid_spot:
                        blocked_slopes.append([slope, quadrant])
                        # The length of this is also the number of asteroids

            if len(blocked_slopes) > max_asteroids:
                max_asteroids = len(blocked_slopes)
                station_location = [jdx, idx] # Convert to xy from yx

    return max_asteroids, station_location

def find_asteroid_annihilated(map, station_location, asteroid_num):

    station_location = station_location[::-1]

    quad_1 = []
    quad_2 = []
    quad_3 = []
    quad_4 = []

    for idx in range(len(map)):
        for jdx in range(len(map[0])):

            # Skip checking blank squares, or against yourself
            if not map[idx][jdx]:
                continue
            elif station_location[0] == idx and station_location[1] == jdx:
                continue

            try:
                slope = float(station_location[0] - idx) / float(station_location[1] - jdx)

                if float(station_location[0] - idx) >= 0 and float(station_location[1] - jdx) > 0:
                    quadrant = 4
                elif float(station_location[0] - idx) >= 0 and float(station_location[1] - jdx) < 0:
                    quadrant = 3
                elif float(station_location[0] - idx) <= 0 and float(station_location[1] - jdx) > 0:
                    quadrant = 2
                elif float(station_location[0] - idx) <= 0 and float(station_location[1] - jdx) < 0:
                    quadrant = 1

            except ZeroDivisionError:
                if float(station_location[0] - idx) < 0:
                    slope = -1 * math.inf
                    quadrant = 2
                else:
                    slope = math.inf
                    quadrant = 1

            distance = (float(station_location[0] - idx)**2.0 + float(station_location[1] - jdx)**2.0)**0.5
            slope = round(slope, 5)

            if quadrant == 1:
                quad_1.append([quadrant, slope, distance, [idx, jdx]])
            elif quadrant == 2:
                quad_2.append([quadrant, slope, distance, [idx, jdx]])
            elif quadrant == 3:
                quad_3.append([quadrant, slope, distance, [idx, jdx]])
            elif quadrant == 4:
                quad_4.append([quadrant, slope, distance, [idx, jdx]])

    quad_1.sort(key = lambda x: (-x[1], x[2]))
    quad_2.sort(key = lambda x: (-x[1], x[2]))
    quad_3.sort(key = lambda x: (x[1], x[2]))
    quad_4.sort(key = lambda x: (x[1], x[2]))

    asteroid_annihilation = quad_1 + quad_2 + quad_3 + quad_4

    previously_annihilated = []
    num_annihilated = 0
    while num_annihilated < asteroid_num:
        annihilated_this_round = []
        for asteroid in asteroid_annihilation:

            skip = False
            for annihilated in previously_annihilated:
                if (asteroid[3][0] == annihilated[3][0] and
                    asteroid[3][1] == annihilated[3][1]):
                    skip = True
                    break

            if skip:
                continue

            for annihilated in annihilated_this_round:
                if (asteroid[1] == annihilated[1]
                    and asteroid[0] == annihilated[0]):
                    skip = True
                    break

            if skip:
                continue

            annihilated_this_round.append(asteroid)
            num_annihilated += 1

        previously_annihilated.extend(annihilated_this_round)

    return previously_annihilated[asteroid_num - 1]

test_files = ["Test1_1.txt", "Test1_2.txt", "Test1_3.txt", "Test1_4.txt", "Test1_5.txt"]
test_results = [8, 33, 35, 41, 210]

puzzle_input = "PuzzleInput.txt"


for idx in range(len(test_files)):

    asteroid_map = create_asteroid_map(test_files[idx])

    max_asteroids, location = find_max_asteroids(asteroid_map)
    assert max_asteroids == test_results[idx]

print("Tests Passed!")

asteroid_map = create_asteroid_map(puzzle_input)
max_asteroids, location = find_max_asteroids(asteroid_map)
print(max_asteroids)

target_asteroid = find_asteroid_annihilated(asteroid_map, location, 200)
print(target_asteroid[3][1]* 100 + target_asteroid[3][0])
