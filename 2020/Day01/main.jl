function main()

    # Initialize array and read in input
    open("Day1/input.txt") do fp
        nums = map(x -> parse(Int, x), readlines(fp))
    end

    # Using sets, calculate remainders from 2020 and then intersect to find numbers in both
    nums = Set(nums)
    remainders = Set(2020 .- nums)
    targets_1 = intersect(nums, remainders)
    
    # Calculate and display what we need
    result_1 = prod(targets_1)
    println("Part 1 result is ", result_1)

    # Use implicit expansion to subtract the numbers
    second_remainders = Set(collect(remainders) .- collect(nums)')
    targets_2 = intersect(nums, second_remainders)

    # Calculate and display what we need
    result_2 = prod(targets_2)
    println("Part 2 result is ", result_2)
end

main()