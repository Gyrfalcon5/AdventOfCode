function main()

    # Read in raw input
    lines = []
    open("Day04/input.txt") do fp
        lines = readlines(fp)
    end

    # To avoid looping over things to add them to the dictionary
    function dict_add!(target, inputs)
        if length(inputs) < 1
            return
        else
            target[inputs[1][1]] = inputs[1][2]
            dict_add!(target, inputs[2:end])
        end
    end

    # Convert the IDs, again without using a loop
    function convert_ids!(output, lines)
        if length(lines) == 0
            return
        elseif lines[1] == ""
            push!(output, Dict())
            convert_ids!(output, lines[2:end])
        else
            curr_line = split.(split(chomp(lines[1]), ' '), ':')
            dict_add!(output[end], curr_line)
            convert_ids!(output, lines[2:end])
        end
    end

    # Do the conversion
    output = [Dict()]
    convert_ids!(output, lines)

    # Validate using sets!
    needed_keys = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
    function validate_id(id, fields)
        return length(intersect(Set(keys(id)), fields)) >= length(fields)
    end

    result_1 = count(map(x -> validate_id(x, needed_keys), output))

    println("Result from part 1 is ", result_1)

    # Make something to validate numbers, and make up functions for purely
    # numeric fields
    function validate_number(num, range)
        value = tryparse(Int, num)

        if isa(value, Nothing)
            return false
        else
            return (value >= range[1] && value <= range[2])
        end
    end

    function validate_byr(byr)
        return validate_number(byr, [1920, 2002])
    end

    function validate_iyr(iyr)
        return validate_number(iyr, [2010, 2020])
    end

    function validate_eyr(eyr)
        return validate_number(eyr, [2020, 2030])
    end

    # Height needs a lil something extra
    function validate_hgt(hgt)
        if occursin("cm", hgt)
            return validate_number(hgt[1:end-2], [150, 193])
        elseif occursin("in", hgt)
            return validate_number(hgt[1:end-2], [59, 76])
        else
            return false
        end
    end

    # Use a combination of simple checks and regex for the remaining fields
    function validate_ecl(ecl)
        valid_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        return count(map(x -> occursin(x, ecl), valid_colors)) > 0
    end

    function validate_hcl(hcl)
        if hcl[1] != '#'
            return false
        elseif length(hcl[2:end]) != 6
            return false
        else
            return length(collect(eachmatch(r"[0-9a-f]", hcl[2:end]))) == 6
        end
    end

    function validate_pid(pid)
        if length(pid) != 9
            return false
        else
            return length(collect(eachmatch(r"[0-9]", pid))) == 9
        end
    end

    # Combine into our final function and calculate
    function deep_validate_id(id)
        return (validate_byr(id["byr"])
                && validate_iyr(id["iyr"])
                && validate_eyr(id["eyr"])
                && validate_hgt(id["hgt"])
                && validate_ecl(id["ecl"])
                && validate_hcl(id["hcl"])
                && validate_pid(id["pid"]))
    end

    output = output[map(x -> validate_id(x, needed_keys), output)]

    result_2 = count(deep_validate_id.(output))

    println("Result from part 2 is ", result_2)
end

main()