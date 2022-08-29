using Memoize

function main()

    adapters = []
    open("Day10/input.txt") do fp
        adapters = parse.(Int, readlines(fp))
    end

    # Is this as easy as I think it is?
    adapters = [0, adapters..., maximum(adapters) + 3]
    sort!(adapters)
    differences = diff(adapters)
    numOnes = count(differences .== 1)
    numThrees = count(differences .== 3)

    result_1 = numOnes * numThrees

    # It is
    println("Result 1 is ", result_1)

    result_2 = arrange_adapters(Tuple(adapters))

    println("Result 2 is ", result_2)

end

# Just do this recursively and cache, math is hard
@memoize function arrange_adapters(adapters)
    if length(adapters) == 1
        return 1
    elseif length(adapters) < 4
        num_ways = 0
        next_steps = sum(adapters[2:end] .<= adapters[1] + 3)
        for idx = (1:next_steps) .+ 1
            num_ways += arrange_adapters(adapters[idx:end])
        end
        return num_ways
    else
        num_ways = 0
        next_steps = sum(adapters[2:4] .<= adapters[1] + 3)
        for idx = (1:next_steps) .+ 1
            num_ways += arrange_adapters(adapters[idx:end])
        end
        return num_ways
    end
end