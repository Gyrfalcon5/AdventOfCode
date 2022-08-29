function main()

    input = []
    open("Day13/input.txt") do fp
        input = readlines(fp)
    end

    current_time = parse(Int, input[1])
    bus_ids = tryparse.(Int, split(input[2], ','))

    # Grab minute offsets
    offsets = findall(bus_ids .!= nothing)

    # filter out out of service buses
    bus_ids = Array{Int}(bus_ids[offsets])

    # Adjust offset for indexing at 1
    offsets = offsets .- 1

    earliest_times = earliest_time.(current_time, bus_ids)

    min_time, min_index = findmin(earliest_times)

    result_1 = (min_time - current_time) * bus_ids[min_index]

    println(result_1)

    # Credit to @PapaNachos on Tildes for their hints/code
    not_found = true
    step = 1
    time = 1
    constraint = 1
    while not_found
        not_found = false

        # apply constraint
        if mod(time + offsets[constraint], bus_ids[constraint]) != 0
            time += step
            not_found = true
        end

        # Check to see if we have applied all constraints, if not, add another and keep going
        if !not_found && constraint < length(bus_ids)
            step *= bus_ids[constraint]
            constraint += 1
            not_found = true
        end
    end
    println(time)

end


function earliest_time(current_time, bus_time)
    return Int(ceil(current_time / bus_time) * bus_time)
end

main()