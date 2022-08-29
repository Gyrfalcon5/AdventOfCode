function main()

    # Initialize array and read in input
    lines = []
    open("Day03/input.txt") do fp
        lines = readlines(fp)
    end

    # Do a quick conversion to a map of true for trees
    function tree_convert(row)
        return map(x -> x == '#', collect(row))
    end
    slope_map = map(x -> tree_convert(x), lines)

    # Define a recursive function that counts up the trees
    function tree_count(step, pos=[1,1])
        if pos[1] > length(slope_map)
            return 0
        # We have to have an extra case because Julia indexes from 1
        elseif mod(pos[2], length(slope_map[1])) == 0
            return (slope_map[pos[1]][length(slope_map[1])] +
                    tree_count(step, pos + step))
        else
            return (slope_map[pos[1]][mod(pos[2], length(slope_map[1]))] +
                    tree_count(step, pos + step))
        end
    end

    # Calculate and display results
    println("Part 1 result is ", tree_count([1, 3]))

    println("Part 2 result is ", tree_count([1, 1])
                               * tree_count([1, 3])
                               * tree_count([1, 5])
                               * tree_count([1, 7])
                               * tree_count([2, 1]))
end

main()