class Planet(object):

    def __init__(self, position, velocity=None):

        self.position = position
        if velocity is None:
            self.velocity = [0, 0, 0]
        else:
            self.velocity = velocity

    @property
    def potential_energy(self):
        pot = 0
        for idx in range(3):
            pot += abs(self.position[idx])
        return pot

    @property
    def kinetic_energy(self):
        kin = 0
        for idx in range(3):
            kin += abs(self.velocity[idx])
        return kin

    @property
    def total_energy(self):
        return self.potential_energy * self.kinetic_energy

    def update_velocity(self, planets):

        for planet in planets:

            for idx in range(3):

                if planet.position[idx] > self.position[idx]:
                    self.velocity[idx] += 1
                elif planet.position[idx] < self.position[idx]:
                    self.velocity[idx] -= 1
                else:
                    pass

    def update_position(self):

        for idx in range(3):
            self.position[idx] += self.velocity[idx]
