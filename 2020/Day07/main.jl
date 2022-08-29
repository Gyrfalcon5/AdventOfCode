# Find how many bags can hide a target bag, kinda recursively
function hide_bag(target, bags, current)

    # We can't hide a bag in itself
    if current == target
        return false
    end
    
    # Can't hide a bag in a bag that's not real or empty
    curr_contents = get(bags, current, nothing)
    if isa(curr_contents, Nothing)
        return false
    end

    # Check if our current bag holds our target, if not, check the bags it does hold
    curr_bag_types = [content[1] for content in curr_contents]
    if target in curr_bag_types
        return true
    else
        return any([hide_bag(target, bags, new_bag) for new_bag in curr_bag_types])
    end

end

# Find out how many bags must be in a bag, kinda recursively
function number_contained(bags, current)

    # If a bag doesn't have anything in it, it's 1 bag
    curr_contents = get(bags, current, nothing)
    if isa(curr_contents, Nothing)
        return 1
    else
        # Otherwise it's one bag plus the quantities of bags it contains times
        # how many bags they in turn contain
        curr_bag_types = [content[1] for content in curr_contents]
        curr_bag_nums = [content[2] for content in curr_contents]
        return 1 + sum(curr_bag_nums .* [number_contained(bags, type) for type in curr_bag_types])
    end
end

function main()

    # Get the input
    input = []
    open("Day07/input.txt") do fp
        input = split.(readlines(fp), ' ')
    end

    # Do the gross work of parsing the input into a dictionary
    bag_mapping = Dict()
    for line in input
        bag = line[1] * " " * line[2]

        if line[5] == "no"
            bag_mapping[bag] = nothing
            continue
        end

        idx = 5
        contents = []
        # This could probably be a for loop, but eh
        while idx < length(line)
            number = parse(Int, line[idx])
            inside_bag = line[idx+1] * " " * line[idx+2]
            push!(contents, (inside_bag, number))
            idx += 4
        end
        bag_mapping[bag] = contents
    end

    # Calculate and print results
    result_1 = count([hide_bag("shiny gold", bag_mapping, bag) for bag in keys(bag_mapping)])
    println("Result for part 1 is ", result_1)

    # This is a hack to discount the very top bag, but eh
    result_2 = number_contained(bag_mapping, "shiny gold") - 1
    println("Result for part 2 is ", result_2)
    
end

main()