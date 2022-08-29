function main()

    # Read input
    lines = []
    open("Day05/input.txt") do fp
        lines = readlines(fp)
    end

    # Apply our function using list comprehensions to get our numbers
    rows = [bin_range(code[1:7], 'F', 127) for code in lines]
    columns = [bin_range(code[8:end], 'L', 7) for code in lines]
    ids = sort([coord[1] * 8 + coord[2] for coord in zip(rows, columns)])

    println("Part 1 result is ", ids[end])

    # Thanks to added sort on line 12, just look for a big diff
    my_seat = ids[argmax(ids[2:end] .- ids[1:end-1])] + 1

    println("Part 2 result is ", my_seat)

end

# Little function to generally loop through and binary search
function bin_range(code, lower, range_max)
    max = range_max
    min = 0
    for letter in code
        if letter == lower
            max -= Int(floor((max - min) / 2))
        else
            min += Int(ceil((max - min) / 2))
        end
    end
    return min
end
        

main()