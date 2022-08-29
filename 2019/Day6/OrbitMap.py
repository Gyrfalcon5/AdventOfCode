class OrbitObject(object):

    def __init__(self, orbits=[], orbiters=[], id=""):

        self.orbits = orbits
        self.orbiters = orbiters
        self.id = id

def read_map(file_name):

    with open(file_name, 'r') as fid:
        data = fid.readlines()

    for idx in range(len(data)):
        data[idx] = data[idx].strip().split(')')

    return data

def find_root_id(map):

    # Find the root of the tree. Apparently this didn't need to be general but
    # it is now!
    roots = [item[0] for item in map]
    leaves = [item[1] for item in map]

    for item in roots:
        if item not in leaves:
            return item

    raise ValueError("Tree has no root!")

def map_to_tree(map, root=None):

    if root is None:
        root_id = find_root_id(map)

        root = OrbitObject([], [], root_id)

    root_orbiters = [item[1] for item in map if item[0] == root.id]

    for orbiter in root_orbiters:
        new_orbiter = OrbitObject(root, [], orbiter)
        root.orbiters.append(new_orbiter)
        map_to_tree(map, new_orbiter)

    return root

def total_orbits(root, depth=1):

    orbit_sum = 0
    orbit_sum += (len(root.orbiters) * depth)

    for orbiter in root.orbiters:
        orbit_sum += total_orbits(orbiter, depth + 1)

    return orbit_sum

def find_path_by_id(root, id, path=[]):

    if root.id == id:
        return 1
    else:
        if len(path) == 0:
            path.insert(0, root)
        for orbiter in root.orbiters:
            find = find_path_by_id(orbiter, id, path)
            if find is not None:
                path.insert(1, orbiter)
                return path

    return None

def dist_between(root, id_1, id_2):

    first_path = find_path_by_id(root, id_1, [])
    second_path = find_path_by_id(root, id_2, [])

    for idx in range(len(first_path)):
        if first_path[idx].id == second_path[idx].id:
            continue
        else:
            pivot_num = idx
            break

    dist = len(first_path[pivot_num:]) + len(second_path[pivot_num:]) - 2
    return dist

input_file = "PuzzleInput.txt"

input_map = read_map(input_file)

root = map_to_tree(input_map)

num_orbits = total_orbits(root)

print(num_orbits)

transfers = dist_between(root, "YOU", "SAN")

print(transfers)
