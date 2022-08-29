function main()

    input = []
    open("Day16/input.txt") do fp
        input = split(readchomp(fp), "\n\n")
    end

    input_fields = split.(split(input[1], '\n'), ": ")
    fields = Dict()
    for field in input_fields
        values = split.(split(field[2], " or "), '-')
        fields[field[1]] = parse.(Int, [values[1][1], values[1][2],
                                        values[2][1], values[2][2]])
    end
    
    my_ticket = split.(split(input[2], '\n')[2], ',')
    my_ticket = [parse(Int, val) for val in my_ticket]
    
    nearby_tickets = split.(split(input[3], '\n')[2:end], ',')
    nearby_tickets = [[parse(Int, val) for val in ticket] for ticket in nearby_tickets]

    error_rate = 0
    for ticket in nearby_tickets
        error_rate += basic_validation(ticket, fields)[1]
    end

    println(error_rate)

    for idx in length(nearby_tickets):-1:1
        if basic_validation(nearby_tickets[idx], fields)[2]
            deleteat!(nearby_tickets, idx)
        end
    end

    ordered_fields = find_fields(nearby_tickets, fields)

    departure_fields = [value for (key, value) in ordered_fields if startswith(key, "departure")]

    println(prod(my_ticket[departure_fields]))

end

function basic_validation(ticket, fields)
    for value in ticket
        valid = false
        for bounds in values(fields)
            if (bounds[1] <= value <= bounds[2]) || (bounds[3] <= value <= bounds[4])
                valid = true
            end
        end
        if !valid
            return (value, true)
        end
    end
    return (0, false)
end

function find_fields(tickets, fields)
    field_order = Dict()
    possibilities = Dict()
    for (name, bounds) in fields
        for row in 1:length(tickets[1])
            values = [ticket[row] for ticket in tickets]
            if all(((bounds[1] .<= values) .& (values .<= bounds[2]))
                    .| ((bounds[3] .<= values) .& (values .<= bounds[4])))
                if name in keys(possibilities)
                    push!(possibilities[name], row)
                else
                    possibilities[name] = Set([row])
                end
            end
        end
    end

    while true
        
        singletons = [name for (name, value) in possibilities if length(value) == 1]
        single_val = possibilities[singletons[1]]
        delete!(possibilities, singletons[1])
        field_order[singletons[1]] = collect(single_val)[1]

        if length(possibilities) < 1
            break
        end

        for key in collect(keys(possibilities))
            setdiff!(possibilities[key], single_val)
        end
    end

    return field_order
end

main()