def read_paths(file_name):

    with open(file_name, 'r') as fid:
        path_1 = fid.readline().strip().split(',')
        path_2 = fid.readline().strip().split(',')

    return path_1, path_2

# TODO: Make another version that finds the locations again and then use that to
# the number of steps needed
def find_corners(path):

    corners = [[0, 0]]

    for move in path:

        num_moves = int(move[1:])
        initial_pos = corners[-1]

        if move[0] == 'R':

            new_pos = [initial_pos[0] + num_moves, initial_pos[1]]
            corners.append(new_pos)

        elif move[0] == 'L':

            new_pos = [initial_pos[0] - num_moves, initial_pos[1]]
            corners.append(new_pos)

        elif move[0] == 'D':

            new_pos = [initial_pos[0], initial_pos[1] - num_moves]
            corners.append(new_pos)

        elif move[0] == 'U':

            new_pos = [initial_pos[0], initial_pos[1] + num_moves]
            corners.append(new_pos)

        else:
            raise ValueError("Invalid direction letter!")

    return corners

def find_intersections(corners_1, path_1, corners_2, path_2):
    intersections = []
    step_idx = []
    for idx in range(len(path_1)):
        for jdx in range(len(path_2)):
            move_1 = path_1[idx]
            move_2 = path_2[jdx]

            # Check cases that could intersect
            if move_1[0] == 'R' and move_2[0] == 'U':
                if (corners_1[idx][0] < corners_2[jdx][0] and
                    corners_1[idx+1][0] > corners_2[jdx][0] and
                    corners_1[idx][1] > corners_2[jdx][1] and
                    corners_1[idx][1] < corners_2[jdx+1][1]):
                    intersections.append([corners_2[jdx][0], corners_1[idx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'R' and move_2[0] == 'D':
                if (corners_1[idx][0] < corners_2[jdx][0] and
                    corners_1[idx+1][0] > corners_2[jdx][0] and
                    corners_1[idx][1] < corners_2[jdx][1] and
                    corners_1[idx][1] > corners_2[jdx+1][1]):
                    intersections.append([corners_2[jdx][0], corners_1[idx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'L' and move_2[0] == 'U':
                if (corners_1[idx][0] > corners_2[jdx][0] and
                    corners_1[idx+1][0] < corners_2[jdx][0] and
                    corners_1[idx][1] > corners_2[jdx][1] and
                    corners_1[idx][1] < corners_2[jdx+1][1]):
                    intersections.append([corners_2[jdx][0], corners_1[idx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'L' and move_2[0] == 'D':
                if (corners_1[idx][0] > corners_2[jdx][0] and
                    corners_1[idx+1][0] < corners_2[jdx][0] and
                    corners_1[idx][1] < corners_2[jdx][1] and
                    corners_1[idx][1] > corners_2[jdx+1][1]):
                    intersections.append([corners_2[jdx][0], corners_1[idx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'U' and move_2[0] == 'R':
                if (corners_1[idx][1] < corners_2[jdx][1] and
                    corners_1[idx+1][1] > corners_2[jdx][1] and
                    corners_1[idx][0] > corners_2[jdx][0] and
                    corners_1[idx][0] < corners_2[jdx+1][0]):
                    intersections.append([corners_1[idx][0], corners_2[jdx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'U' and move_2[0] == 'L':
                if (corners_1[idx][1] < corners_2[jdx][1] and
                    corners_1[idx+1][1] > corners_2[jdx][1] and
                    corners_1[idx][0] < corners_2[jdx][0] and
                    corners_1[idx][0] > corners_2[jdx+1][0]):
                    intersections.append([corners_1[idx][0], corners_2[jdx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'D' and move_2[0] == 'R':
                if (corners_1[idx][1] > corners_2[jdx][1] and
                    corners_1[idx+1][1] < corners_2[jdx][1] and
                    corners_1[idx][0] > corners_2[jdx][0] and
                    corners_1[idx][0] < corners_2[jdx+1][0]):
                    intersections.append([corners_1[idx][0], corners_2[jdx][1]])
                    step_idx.append([idx, jdx])
            elif move_1[0] == 'D' and move_2[0] == 'L':
                if (corners_1[idx][1] > corners_2[jdx][1] and
                    corners_1[idx+1][1] < corners_2[jdx][1] and
                    corners_1[idx][0] < corners_2[jdx][0] and
                    corners_1[idx][0] > corners_2[jdx+1][0]):
                    intersections.append([corners_1[idx][0], corners_2[jdx][1]])
                    step_idx.append([idx, jdx])


    return intersections, step_idx

def determine_closest(intersections):

    distances = []


    for intersection in intersections:
        distances.append(abs(intersection[0]) + abs(intersection[1]))

    return min(distances)

def least_steps(intersections, corners_1, corners_2, path_1, path_2, moves):

    total_steps = []

    for idx in range(len(intersections)):

        steps_1 = 0
        steps_2 = 0

        for jdx in range(moves[idx][0]):
            steps_1 += int(path_1[jdx][1:])

        for jdx in range(moves[idx][1]):
            steps_2 += int(path_2[jdx][1:])

        steps_1 += (abs(intersections[idx][0] - corners_1[moves[idx][0]][0])
                    + abs(intersections[idx][1] - corners_1[moves[idx][0]][1]))
        steps_2 += (abs(intersections[idx][0] - corners_2[moves[idx][1]][0])
                    + abs(intersections[idx][1] - corners_2[moves[idx][1]][1]))

        total_steps.append(steps_1 + steps_2)

    return min(total_steps)

def closest_intersection_dist(data_file):
    path_1, path_2 = read_paths(data_file)

    corners_1 = find_corners(path_1)
    corners_2 = find_corners(path_2)

    intersections, steps = find_intersections(corners_1, path_1, corners_2, path_2)

    return determine_closest(intersections)

def least_steps_intersection(data_file):

    path_1, path_2 = read_paths(data_file)

    corners_1 = find_corners(path_1)
    corners_2 = find_corners(path_2)

    intersections, moves = find_intersections(corners_1, path_1, corners_2, path_2)

    return least_steps(intersections, corners_1, corners_2, path_1, path_2, moves)

test_files = ["Test1.txt", "Test2.txt"]
test_results_1 = [159, 135]
test_results_2 = [610, 410]
input_file = "PathInput.txt"


# Run our tests!
print("Running tests")
for idx in range(len(test_files)):

    distance = closest_intersection_dist(test_files[idx])

    assert distance  == test_results_1[idx]

print("Tests passed!")

print("Running problem data...")

distance = closest_intersection_dist(input_file)

print("The closest distance found is {}".format(distance))

print("Running tests")

for idx in range(len(test_files)):

    num_steps = least_steps_intersection(test_files[idx])

    assert num_steps == test_results_2[idx]

print("Tests passed!")

print("Running problem data...")

num_steps = least_steps_intersection(input_file)

print("The least steps instersection takes {} steps.".format(num_steps))
