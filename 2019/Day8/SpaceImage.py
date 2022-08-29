def read_image(file_name):

    with open(file_name, 'r') as fid:
        raw_image = fid.read().strip()

    return raw_image

def layerize_image(raw_image, height, width):

    raw_image = [int(num) for num in raw_image]

    count = 0
    layered_image = []

    while count < len(raw_image):
        layer = []
        for i in range(height):
            row = []
            for j in range(width):
                row.append(raw_image[count])
                count += 1

            layer.append(row)
        layered_image.append(layer)

    return layered_image

def count_layer_instances(layer_img, target):

    layer_totals = []

    for layer in layer_img:
        count = 0
        for row in layer:
            for num in row:
                if num == target:
                    count += 1

        layer_totals.append(count)

    return layer_totals

def validate_image(input_file, height, width):

    raw_image = read_image(input_file)

    layer_img = layerize_image(raw_image, height, width)

    zeros = count_layer_instances(layer_img, 0)

    target_layer = zeros.index(min(zeros))

    ones = count_layer_instances(layer_img, 1)
    twos = count_layer_instances(layer_img, 2)

    return ones[target_layer] * twos[target_layer]

def display_image(image):

    for row in image:
        row_str = ""
        for num in row:
            if num:
                row_str += str(num)
            else:
                row_str += " "
        print(row_str)

def decode_image(input_file, height, width):

    raw_image = read_image(input_file)

    layer_img = layerize_image(raw_image, height, width)

    done_pixels = [[False for i in range(width)] for j in range(height)]
    final_img = [[0 for i in range(width)] for j in range(height)]

    for layer in layer_img:

        for idx in range(height):
            for jdx in range(width):

                if not done_pixels[idx][jdx]:
                    if layer[idx][jdx] != 2:
                        final_img[idx][jdx] = layer[idx][jdx]
                        done_pixels[idx][jdx] = True

    display_image(final_img)
    return final_img


input_file = "PuzzleInput.txt"
layer_width = 25
layer_height = 6

result = validate_image(input_file, layer_height, layer_width)

print(result)

final_img = decode_image(input_file, layer_height, layer_width)
