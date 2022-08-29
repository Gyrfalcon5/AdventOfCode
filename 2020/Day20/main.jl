# Just going to write some notes here
# I think it is possible to rotate the matrices using
# a combo of transpose and reverse
# Try to see if sparse arrays will work, should be able to 
# reduce memory usage and computation
# Also see if you can make each group of edges a set, then use
# that to find edges that only occur once, then use that to
# determine orientation of the squares

function main()

    input = []
    open("Day20/input.txt") do fp
        input = split(readchomp(fp), "\n\n")
    end

    tiles = Dict()
    for tile in input
        rows = split(tile, '\n')
        id = parse(Int, rows[1][6:end-1])
        tile = hcat([[val == '#' for val in row] for row in rows[2:end]]...)'
        tiles[id] = tile
        
    end

    all_possible_edges = Dict([key => get_edge_permutations(value) for (key, value) in tiles])
    
    shared_edges = Dict()
    for (id,edges) in all_possible_edges
        for (other_id, other_edges) in all_possible_edges
            if other_id != id
                if length(intersect(edges, other_edges)) == 2
                    if !(id in keys(shared_edges))
                        shared_edges[id] = [other_id]
                    else
                        push!(shared_edges[id], other_id)
                    end
                end
            end
        end
    end

    println(prod(key for (key,value) in shared_edges if length(value) == 2))
end

function get_edges(tile)
    top = Tuple(collect(tile[1,idx] for idx in 1:10))
    bottom = Tuple(collect(tile[10,idx] for idx in 1:10))
    left = Tuple(collect(tile[idx,1] for idx in 1:10))
    right = Tuple(collect(tile[idx,10] for idx in 1:10))
    return [top, bottom, left, right]
end

function get_edge_permutations(tile)
    return [get_edges(tile)..., collect(reverse(edge) for edge in get_edges(tile))...]
end

main()