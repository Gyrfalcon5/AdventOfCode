function main()

    input = []
    open("Day18/input.txt") do fp
        input = clean_input.(readlines(fp))
    end

    println(sum(eval_expression.(input)))

    println(sum(eval_expression2.(input)))

end

function clean_input(line)
    return_line = Array{Any}([letter for letter in line if letter != ' '])
    for idx = 1:length(return_line)
        if match(r"[()+*]", string(return_line[idx])) == nothing
            return_line[idx] = parse(Int, return_line[idx])
        end
    end
    return return_line
end

function eval_expression(line)
    if length(line) < 3
        return line[1]
    elseif line[1] == '('
        close = find_paren_match(line[2:end], 0)
        return eval_expression([eval_expression(line[2:close])...,
                                line[close+2:end]...])
    elseif line[3] == '('
        close = find_paren_match(line[4:end], 2)
        return eval_expression([line[1:2]...,
                                eval_expression(line[4:close])...,
                                line[close+2:end]...])
    elseif line[2] == '+'
        return eval_expression([line[1] + line[3], line[4:end]...])
    elseif line[2] == '*'
        return eval_expression([line[1] * line[3], line[4:end]...])
    end
end

function eval_expression2(line)
    if length(line) < 3
        return line[1]
    elseif line[1] == '('
        close = find_paren_match(line[2:end], 0)
        return eval_expression2([eval_expression2(line[2:close])...,
                                line[close+2:end]...])
    elseif line[3] == '('
        close = find_paren_match(line[4:end], 2)
        return eval_expression2([line[1:2]...,
                                eval_expression2(line[4:close])...,
                                line[close+2:end]...])
    elseif line[2] == '+'
        return eval_expression2([line[1] + line[3], line[4:end]...])
    elseif line[2] == '*' && length(line) >= 4 && line[4] != '+'
        return eval_expression2([line[1] * line[3], line[4:end]...])
    else
        return line[1] * eval_expression2(line[3:end])
    end
end

function find_paren_match(line, offset)
    paren_count = 1
    for (idx,character) in enumerate(line)
        if character == '('
            paren_count += 1
        elseif character == ')'
            paren_count -= 1
        end

        if paren_count == 0
            return idx + offset
        end
    end
end
        

main()