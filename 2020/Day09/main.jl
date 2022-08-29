function main()

    input = []
    open("Day09/input.txt") do fp
        input = parse.(Int, readlines(fp))
    end

    error_location = find_encoding_error(input, 25)
    result_1 = input[error_location]

    println("Result 1 is ", result_1)

    result_2 = encoding_cracker(input, result_1)

    println("Result 2 is ", result_2)
end

# Loops through to find which value is broken
function find_encoding_error(code, preamble_len)

    for idx = preamble_len+1:length(code)
        valid = encoding_check(code[idx-preamble_len:idx])
        if !valid
            return idx
        end
    end
    return nothing
end

# Checks if any of the values in the preceding numbers can sum to the target
function encoding_check(code)
    target = code[end]
    values = code[1:end-1]
    remainders = target .- values
    possibilities = remainders .+ values'
    return any(x -> x in values, remainders)

end

# Loops through to crack encoding
function encoding_cracker(code, target)

    for idx = 1:length(code)-1
        jdx = idx + 1
        sum = code[idx] + code[jdx]
        while sum < target
            jdx += 1
            sum += code[jdx]
        end
        
        if sum == target
            return minimum(code[idx:jdx]) + maximum(code[idx:jdx])
        else
            continue
        end
    end
    return nothing
end

main()