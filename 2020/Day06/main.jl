function main()

    # Read input the lazy way
    input = nothing
    open("Day06/input.txt") do fp
        input = split(readchomp(fp), "\n\n")
    end

    # Clean up input and map deploy our function
    answers = map(x -> split(x, '\n'), input)
    result_1 = sum(count_yes.(answers))
    println("Part 1 result is ", result_1)

    result_2 = sum(count_unanimous.(answers))
    println("Part 2 result is ", result_2)

end

# Add every answer to a set, unique yes answers are the length
function count_yes(answer)
    questions = Set()
    for response in answer
        for question in response
            push!(questions, question)
        end
    end
    return length(questions)
end

# Add answers from each person to a set and intersect to get unanimity
function count_unanimous(answer)
    clean_responses = []
    for response in answer
        clean_response = Set()
        for question in response
            push!(clean_response, question)
        end
        push!(clean_responses, clean_response)
    end
    return length(intersect(clean_responses...))
end

main()