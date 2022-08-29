import matplotlib.pyplot as plt

class PaintBot(object):

    def __init__(self, location=None, first_color=0):

        if location is None:
            self.location = [0,0]
        else:
            self.location = location

        self.map = {tuple(self.location) : first_color}
        self.heading = 1 # Corresponds to up

    def paint(self, color):

        self.map[tuple(self.location)] = color

    def update_map(self):
        if tuple(self.location) not in self.map:
            self.map[tuple(self.location)] = 0

    def move(self, turn_instruction):

        if turn_instruction == 1: # Turn right
            self.heading += 1
        elif turn_instruction == 0: # Turn left
            self.heading -= 1
        else:
            raise ValueError("Improper turn instruction given!")

        # Bound the heading
        if self.heading == 0:
            self.heading = 4
        elif self.heading == 5:
            self.heading = 1

        # Move the robot
        if self.heading == 1:
            self.location[1] += 1
        elif self.heading == 2:
            self.location[0] += 1
        elif self.heading == 3:
            self.location[1] -= 1
        elif self.heading == 4:
            self.location [0] -= 1
        else:
            raise ValueError("Heading at improper value!")

        self.update_map()

    def read_current_tile(self):
        return self.map[tuple(self.location)]

    # This is a totally overkill solution lol
    def show_painting(self):

        data = {"x":[], "y":[]}
        for coord, color in self.map.items():
            if color:
                data["x"].append(coord[0])
                data["y"].append(coord[1])

        plt.figure()
        plt.scatter(data["x"], data["y"], marker = 'o')
        plt.show()
