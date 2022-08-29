import math, copy
import numpy as np


def get_signal(file_name):

    with open(file_name, 'r') as fid:
        data = fid.read().strip()

    data = [int(x) for x in data]

    return data

def generate_pattern(round):

    return np.repeat([0, 1, 0, -1], round)

def lcm(a, b):
    return abs(a * b) // math.gcd(a, b)

def calc_new_signal(signal, offset):

    new_signal = np.zeros(len(signal))

    for round in range(offset, len(signal)):

        item_total = 0

        print(f"Round {round} reached")

        pattern = generate_pattern(round+1)
        pattern = np.append(pattern[1:], 0)

        pattern = np.tile(pattern, math.ceil(len(signal) / len(pattern)) + 1)
        pattern = pattern[:len(signal)]
        signal_array = signal[pattern != 0]
        pattern = pattern[pattern != 0]

        new_signal[round] = abs(sum(pattern * signal_array)) % 10

    return new_signal

def run_fft(signal, num_phases, offset):

    new_signal = copy.copy(signal)

    for phase in range(num_phases):
        print(f"Phase {phase} reached")
        new_signal = calc_new_signal(new_signal, offset)

    return new_signal

if __name__ == "__main__":

    input_file = "PuzzleInput.txt"

    signal = get_signal(input_file)

    """
    thing = run_fft(np.array(signal), 100, 0)
    print(''.join(map(str, map(int, thing[:8]))))

    """
    signal = [int(x) for x in "03036732577212944063491565474664"]

    real_signal = signal * 10000

    message_offset = real_signal[:7]
    message_offset = int(''.join(map(str, message_offset)))

    thing = run_fft(np.array(real_signal), 100, message_offset)
