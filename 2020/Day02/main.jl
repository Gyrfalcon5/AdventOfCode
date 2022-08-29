function main()

    lines = []
    # Initialize array and read in input
    open("Day2/input.txt") do fp
        lines = readlines(fp)
    end

    # Split out everything appropriately
    lines = map(x -> split(x, ' '), lines)
    ranges = map(x -> split(x[1], '-'), lines)
    ranges = map(x -> [parse(Int, x[1]), parse(Int, x[2])], ranges)
    letters = map(x -> x[2][1], lines)
    passwords = map(x -> x[3], lines)

    # Define function for checking passwords
    function check_pw1(range, letter, pw)
        matches = count(x -> (x == letter), pw)
        return range[1] <= matches <= range[2]
    end

    # Run the check and display result
    result1 = count(map(check_pw1, ranges, letters, passwords))
    println("Part 1 result is ", result1)

    # Define new function for checking passwords
    function check_pw2(positions, letter, pw)
        return xor(pw[positions[1]] == letter, pw[positions[2]] == letter)
    end

    # Run the check and display result
    result2 = count(map(check_pw2, ranges, letters, passwords))
    println("Part 2 result is ", result2)

end

main()