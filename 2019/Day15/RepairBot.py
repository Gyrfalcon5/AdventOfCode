import random
import copy
import Intputer

class RepairBot(object):

    def __init__(self, brain_instructions):

        self.brain = Intputer.Intputer(copy.copy(brain_instructions))
        self.initial_instructions = copy.copy(brain_instructions)
        self.location = [0, 0]
        self.map = {}
        self.map[tuple(self.location)] = 1
        self.move_history = []

    def reinitialize_brain(self):

        self.brain = Intputer.Intputer(copy.copy(self.initial_instructions))

    def move(self, direction):

        self.brain.process_instructions(direction)
        change_location = True
        if self.brain.output_buffer[-1] == 0:
            change_location = False

        new_location = copy.copy(self.location)

        if direction == 1:
             new_location[0] += 1
        elif direction == 2:
            new_location[0] -= 1
        elif direction == 3:
            new_location[1] -= 1
        elif direction == 4:
            new_location[1] += 1

        self.map[tuple(new_location)] = self.brain.output_buffer[-1]
        self.brain.clear_output_buffer()

        if change_location:
            self.location = new_location


    def find_valid_moves(self):
        valids = []
        locations = [(self.location[0]+1, self.location[1]),
                     (self.location[0]-1, self.location[1]),
                     (self.location[0], self.location[1]-1),
                     (self.location[0], self.location[1]+1)]

        for idx in range(4):

            try:
                if self.map[tuple(locations[idx])] == 1:
                    valids.append(idx + 1)
            except KeyError:
                # We don't need to do things just if there isn't anything in
                # there it's okay, but maybe we can move there?
                valids.append(idx + 1)

        return valids

    # This is admittedly the stupid way but I guess I'm stupid today
    def find_ox_sys(self):
        preferred_direction = 1

        while True:

            print(len(self.map))
            if 2 in self.map.values() and len(self.map) > 1656:
                return

            valid_moves = self.find_valid_moves()

            self.move(random.choice(valid_moves))

    def path_to_ox(self):

        wavefront_map = {}
        ox_location = list(self.map.keys())[list(self.map.values()).index(2)]
        wavefront_map[ox_location] = 0

        while (0,0) not in wavefront_map.keys():

            wavefront_keys = list(wavefront_map.keys())

            for curr_location in wavefront_keys:
                possible_locations = [(curr_location[0]+1, curr_location[1]),
                                      (curr_location[0]-1, curr_location[1]),
                                      (curr_location[0], curr_location[1]-1),
                                      (curr_location[0], curr_location[1]+1)]

                for possible_location in possible_locations:
                    if (possible_location in self.map.keys()
                        and self.map[possible_location] != 0
                        and possible_location not in wavefront_map.keys()):
                        wavefront_map[possible_location] = wavefront_map[curr_location] + 1

        return wavefront_map[(0,0)]

    def ox_time(self):

        wavefront_map = {}
        ox_location = list(self.map.keys())[list(self.map.values()).index(2)]
        wavefront_map[ox_location] = 0

        while True:
            old_len = len(wavefront_map)

            wavefront_keys = list(wavefront_map.keys())

            for curr_location in wavefront_keys:
                possible_locations = [(curr_location[0]+1, curr_location[1]),
                                      (curr_location[0]-1, curr_location[1]),
                                      (curr_location[0], curr_location[1]-1),
                                      (curr_location[0], curr_location[1]+1)]

                for possible_location in possible_locations:
                    if (possible_location in self.map.keys()
                        and self.map[possible_location] != 0
                        and possible_location not in wavefront_map.keys()):
                        wavefront_map[possible_location] = wavefront_map[curr_location] + 1

            new_len = len(wavefront_map)

            if new_len <= old_len:
                break

        return max(wavefront_map.values())
