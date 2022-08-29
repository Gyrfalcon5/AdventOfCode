using Memoize

function main()

    input = []
    open("Day11/input.txt") do fp
        input = readlines(fp)
    end
    seats = []
    for row in input
        seat_row = []
        for char in row
            push!(seat_row, seat_type(char))
        end
        push!(seats, seat_row)
    end

    result_1 = simulate(deepcopy(seats))

    println(result_1)

    result_2 = simulate2(deepcopy(seats))

    println(result_2)
    
end

function seat_type(seat_code)
    if seat_code == 'L'
        # Empty, can be filled
        return (false, true)
    else
        # Empty, can't be filled
        return (false, false)
    end
end

@memoize function valid_neighbors(location, max)
    y = location[1] .+ [1, 0, -1]
    x = location[2] .+ [1, 0, -1]
    y = y[max[1] .>= y .> 0]
    x = x[max[2] .>= x .> 0]
    return [(y_val, x_val) for x_val in x for y_val in y]
end

@memoize function valid_neighbors2(location, seats, max)
    neighbors = []
    directions = [(1,1), (1,0), (1,-1), (0,1), (0,-1), (-1, 1), (-1,0), (-1,-1)]
    multiplier = 1
    while length(directions) > 0
        for idx = length(directions):-1:1
            neighbor = location .+ (directions[idx] .* multiplier)
            if any(neighbor .> max) || any(neighbor .< 1)
                deleteat!(directions, idx)
            elseif seats[neighbor[1]][neighbor[2]][2] == true
                 push!(neighbors, neighbor)
                 deleteat!(directions, idx)
            end
        end
        multiplier += 1
    end
    return neighbors
end


function simulate(seats)

    max = (length(seats), length(seats[1]))
    changed_seats = 1
    new_seats = deepcopy(seats)
    while changed_seats > 0
        changed_seats = 0
        for ydx = 1:max[1]
            for xdx = 1:max[2]
                if seats[ydx][xdx][2] == false
                    continue
                elseif seats[ydx][xdx][1] == false
                    neighbors = valid_neighbors((ydx,xdx), max)
                    adjacent = 0
                    for neighbor in neighbors
                        if neighbor == (ydx, xdx)
                            continue
                        end
                        adjacent += seats[neighbor[1]][neighbor[2]][1]
                    end
                    if adjacent == 0
                        new_seats[ydx][xdx] = (true, true)
                        changed_seats += 1
                    else
                        continue
                    end
                elseif seats[ydx][xdx][1] == true
                    neighbors = valid_neighbors((ydx,xdx), max)
                    adjacent = 0
                    for neighbor in neighbors
                        if neighbor == (ydx, xdx)
                            continue
                        end
                        adjacent += seats[neighbor[1]][neighbor[2]][1]
                    end
                    if adjacent >= 4
                        new_seats[ydx][xdx] = (false, true)
                        changed_seats += 1
                    else
                        continue
                    end
                end
            end
        end
        seats = deepcopy(new_seats)
    end

    return count([seat[1] for row in seats for seat in row])

end

function simulate2(seats)

    max = (length(seats), length(seats[1]))
    changed_seats = 1
    new_seats = deepcopy(seats)
    while changed_seats > 0
        changed_seats = 0
        for ydx = 1:max[1]
            for xdx = 1:max[2]
                if seats[ydx][xdx][2] == false
                    continue
                elseif seats[ydx][xdx][1] == false
                    neighbors = valid_neighbors2((ydx,xdx), seats, max)
                    adjacent = 0
                    for neighbor in neighbors
                        if neighbor == (ydx, xdx)
                            continue
                        end
                        adjacent += seats[neighbor[1]][neighbor[2]][1]
                    end
                    if adjacent == 0
                        new_seats[ydx][xdx] = (true, true)
                        changed_seats += 1
                    else
                        continue
                    end
                elseif seats[ydx][xdx][1] == true
                    neighbors = valid_neighbors2((ydx,xdx), seats, max)
                    adjacent = 0
                    for neighbor in neighbors
                        if neighbor == (ydx, xdx)
                            continue
                        end
                        adjacent += seats[neighbor[1]][neighbor[2]][1]
                    end
                    if adjacent >= 5
                        new_seats[ydx][xdx] = (false, true)
                        changed_seats += 1
                    else
                        continue
                    end
                end
            end
        end
        seats = deepcopy(new_seats)
    end

    return count([seat[1] for row in seats for seat in row])

end

main()