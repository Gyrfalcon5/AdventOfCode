function main()

    input = []
    open("Day19/input2.txt") do fp
        input = split(readchomp(fp), "\n\n")
    end

    messages = split(input[2], '\n')
    rules = split(input[1], '\n')

    rule_dict = Dict()
    for rule in rules
        rule_dict[parse(Int, split(rule, ": ")[1])] = parse_rule(split(rule, ": ")[2])
    end
    
    target1 = Regex("(*NO_JIT)" * construct_regex(rule_dict, 11) * "\$")
    target2 = Regex("^" * construct_regex(rule_dict, 8) * "\$")
    count = 0
    for message in messages
        if match(target1, message) !== nothing
            short_message = message[1:match(target1, message).offset-1]
            if match(target2, short_message) !== nothing
                println(message)
                count += 1
            end
        end
    end
    println(count)
    
end

function parse_rule(rule)
    if match(r"[a-z]", rule) != nothing
        return rule[2]
    elseif contains(rule, "|")
        return [parse.(Int, split(split(rule, " | ")[1], ' ')), 
                parse.(Int, split(split(rule, " | ")[2], ' '))]
    else
        return parse.(Int, split(rule, ' '))
    end
end

function construct_regex(rules, start_rule, depth=0)

    if isa(rules[start_rule], Array{Int,1})
        return string(collect(construct_regex(rules, start) for start in rules[start_rule])...)
    elseif isa(rules[start_rule], Char)
        return string(rules[start_rule])
    elseif isa(rules[start_rule], Array{Array{Int,1}})
        if start_rule in rules[start_rule][2]
            if length(rules[start_rule][2]) == 2
                return string(construct_regex(rules, rules[start_rule][1][1]), "+")
            elseif length(rules[start_rule][2]) == 3
                if depth == 0
                    return string("(", construct_regex(rules, rules[start_rule][1][1]), "(",
                                    construct_regex(rules, 11, depth+1), ")*",
                                    construct_regex(rules, rules[start_rule][1][2]), ")")
                elseif depth < 16
                    return string("(", construct_regex(rules, rules[start_rule][1][1]), "(",
                                    construct_regex(rules, 11, depth+1), ")*",
                                    construct_regex(rules, rules[start_rule][1][2]), ")*")
                else
                    return ""
                end
            else
                println("AH2") # for emergency use
            end
        else
            return string("(", 
                collect(construct_regex(rules, start) for start in rules[start_rule][1])...,
                "|", collect(construct_regex(rules, start) for start in rules[start_rule][2])...,
                ")")
        end
    else
        return "AH" # for emergency use
    end
end

main()