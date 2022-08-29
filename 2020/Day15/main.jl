function main()

    input = []
    open("Day15/input.txt") do fp
        input = parse.(Int32, split(readchomp(fp), ','))
    end

    game = Dict{Int32, Tuple{Int32, Int32}}()

    for (idx, num) in enumerate(input)
        add_num!(game, idx, num)
    end

    result_1 = play_game!(deepcopy(game), 2020, input[end])
    println(result_1)

    result_2 = play_game!(deepcopy(game), 30_000_000, input[end])
    println(result_2)

end

function add_num!(game, turn, num)
    if !(num in keys(game))
        game[num] = (0, turn)
    else
        game[num] = (game[num][2], turn)
    end
end

function play_game!(game, last_turn, first_num)
    first_turn = length(game) + 1
    prev_num = first_num
    for turn = first_turn:last_turn
        prev_num = advance_game!(game, prev_num, turn)
    end
    return prev_num
end

function advance_game!(game, prev_num, turn)
    if game[prev_num][1] == 0
        add_num!(game, turn, 0)
        new_num = 0
    else
        new_num = game[prev_num][2] - game[prev_num][1]
        add_num!(game, turn, new_num)
    end
    return new_num
end

main()