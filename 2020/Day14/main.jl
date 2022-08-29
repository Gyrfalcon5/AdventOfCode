function main()

    input = []
    open("Day14/input.txt") do fp
        input = split.(readlines(fp), ' ')
    end

    lines = translate_lines(input)
    result_1 = map_memory_sum(lines)

    println(result_1)

    lines_2 = translate_lines2(input)
    result_2 = map_memory_sum2(lines_2)

    println(result_2)

end

function map_memory_sum(lines)

    memory = Dict()
    mask = nothing
    for line in lines
        if line[1] == 'm'
            mask = line[2]
        else
            value = apply_mask(line[3], mask)
            memory[line[2]] = parse(Int, reverse(value), base = 2)
        end
    end
    return sum(values(memory))
end

function map_memory_sum2(lines)

    memory = Dict()
    mask = nothing
    for line in lines
        if line[1] == 'm'
            mask = line[2]
        else
            # TODO: Make this work
            locations = location_mask(mask, line[2])
            for location in locations
                memory[location] = line[3]
            end
        end
    end
    return sum(values(memory))
end


function translate_lines(lines)

    output = []
    for line in lines

        if line[1] == "mask"
            push!(output, ('m', translate_mask(line[3])))
        else
            location = parse(Int, line[1][5:end-1])
            value = reverse(bitstring(parse(Int, line[3])))
            push!(output, ('a', location, value))
        end
    end
    return output
end

function translate_lines2(lines)

    output = []
    for line in lines

        if line[1] == "mask"
            push!(output, ('m', reverse(line[3])))
        else
            location = reverse(bitstring(parse(Int, line[1][5:end-1])))
            value = parse(Int, line[3])
            push!(output, ('a', location, value))
        end
    end
    return output
end

function location_mask(mask, location, trailing="")

    if length(mask) == 0
        return parse(Int, reverse(trailing * location), base = 2)
    elseif mask[1] == '0'
        return [location_mask(mask[2:end], location[2:end], trailing * location[1])...]
    elseif mask[1] == '1'
        return [location_mask(mask[2:end], location[2:end], trailing * "1")...]
    elseif mask[1] == 'X'
        return [location_mask(mask[2:end], location[2:end], trailing * "1")...,
                location_mask(mask[2:end], location[2:end], trailing * "0")...]
    end
end

function translate_mask(mask)
    mask = reverse(mask) # little endian time
    output = Dict()
    for (index, char) in enumerate(mask)
        if char == '1' || char == '0'
            output[index] = string(char)
        end
    end
    return output
end

function apply_mask(value, mask)
    for (location, mask_val) in mask
        value = value[1:location-1] * mask_val * value[location+1:end]
    end
    return value
end



main()