function main()

    input = []
    open("Day12/input.txt") do fp
        input = readlines(fp)
    end

    input = map(x -> (x[1], parse(Int, x[2:end])), input)

    result_1 = manhattan_distance(input)

    println(result_1)

    result_2 = waypoint_distance(input)

    println(result_2)

end

function manhattan_distance(directions)
    east = 0
    north = 0
    heading = 0
    for instruction in directions
        if instruction[1] == 'N'
            north += instruction[2]
        elseif instruction[1] == 'S'
            north -= instruction[2]
        elseif instruction[1] == 'E'
            east += instruction[2]
        elseif instruction[1] == 'W'
            east -= instruction[2]
        elseif instruction[1] == 'R'
            heading = mod(heading + instruction[2], 360)
        elseif instruction[1] == 'L'
            heading = mod(heading - instruction[2], 360)
        else
            if heading == 0
                east += instruction[2]
            elseif heading == 90
                north -= instruction[2]
            elseif heading == 180
                east -= instruction[2]
            else
                north += instruction[2]
            end
            
        end
    end
    return abs(east) + abs(north)
end

function waypoint_distance(directions)
    waypoint = [10, 1] # East, north
    ship = [0, 0] # East, north

    for instruction in directions

        if instruction[1] == 'N'
            waypoint[2] += instruction[2]
        elseif instruction[1] == 'S'
            waypoint[2] -= instruction[2]
        elseif instruction[1] == 'E'
            waypoint[1] += instruction[2]
        elseif instruction[1] == 'W'
            waypoint[1] -= instruction[2]
        elseif instruction[1] == 'R'
            theta = instruction[2]
            waypoint = [waypoint[1] * cosd(theta) + waypoint[2] * sind(theta),
                        -waypoint[1] * sind(theta) + waypoint[2] * cosd(theta)]
        elseif instruction[1] == 'L'
            theta = -instruction[2]
            waypoint = [waypoint[1] * cosd(theta) + waypoint[2] * sind(theta),
                        -waypoint[1] * sind(theta) + waypoint[2] * cosd(theta)]
        else
            ship = ship .+ (waypoint .* instruction[2])
        end
    end

    return sum(abs.(ship))
end

main()

