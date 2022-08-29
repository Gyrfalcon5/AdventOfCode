using Memoize

function main()

    input = []
    open("Day17/input.txt") do fp
        input = readlines(fp)
    end

    map = Dict{NTuple{3,Int}, Int}()
    for (idx, row) in enumerate(input)
        for (jdx, char) in enumerate(row)
            if char == '#'
                map[(jdx, idx, 0)] = 1
            end
        end
    end

    simulate!(map, 6)
    println(sum(values(map)))

    map_4d = Dict{NTuple{4,Int}, Int}()
    for (idx, row) in enumerate(input)
        for (jdx, char) in enumerate(row)
            if char == '#'
                map_4d[(jdx, idx, 0, 0)] = 1
            end
        end
    end

    simulate!(map_4d, 6)
    println(sum(values(map_4d)))

end

@memoize function nearest_neighbors(location::NTuple{3,Int})

    return ((i,j,k) for i in location[1]-1:location[1]+1
                    for j in location[2]-1:location[2]+1
                    for k in location[3]-1:location[3]+1
                    if (i, j, k) != location)
end

# There's gotta be a better way to do this lol
@memoize function nearest_neighbors(location::NTuple{4,Int})

    return ((i,j,k, l) for i in location[1]-1:location[1]+1
                       for j in location[2]-1:location[2]+1
                       for k in location[3]-1:location[3]+1
                       for l in location[4]-1:location[4]+1
                       if (i, j, k, l) != location)
end

function num_active_neighbors(neighbors, map)
    return sum([get(map, neighbor, 0) for neighbor in neighbors])
end

function simulate!(map::Dict{T,Int}, rounds) where T <: NTuple

    for round in 1:rounds

        changes = Dict{T,Int}() # To minimize deepcopying
        curr_active = (key for (key, value) in map if value == 1)
        active_neighbors = Set((location for active in curr_active for location in nearest_neighbors(active)))
        
        for active in curr_active
            if !(1 < num_active_neighbors(nearest_neighbors(active), map) < 4)
                changes[active] = 0
            end
        end

        for neighbor in active_neighbors
            if num_active_neighbors(nearest_neighbors(neighbor), map) == 3
                changes[neighbor] = 1
            end
        end

        apply_changes!(map, changes)
    end
end

function apply_changes!(map, changes)
    for (location, change) in changes
        map[location] = change
    end
end

main()