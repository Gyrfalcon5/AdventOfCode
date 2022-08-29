include("Assembly.jl")
import .Assembly

function main()

    input = []
    open("Day08/input.txt") do fp
        input = Assembly.parse_instruction.(split.(readlines(fp), ' '))
    end

    machine = Assembly.MachineState(input)

    result_1, stack_trace = infinite_loop_finder(machine)
    println("Part 1 result is ", result_1)

    result_2 = infinite_loop_fixer(machine, stack_trace)
    println("Part 2 result is ", result_2)

end

# Find the infinite loop by comparing current instruction pointer locations to
# ones that have come before
function infinite_loop_finder(machine::Assembly.MachineState)
    old_pointers = [machine.instruction_pointer]
    old_accumulator = machine.accumulator
    no_repeat = true

    while no_repeat
        machine = Assembly.advance(machine)
        if machine.instruction_pointer in old_pointers
            no_repeat = false

        elseif Assembly.complete(machine)
            return machine.accumulator, nothing
        else
            push!(old_pointers, machine.instruction_pointer)
            old_accumulator = machine.accumulator
        end
    end

    return old_accumulator, old_pointers
end

# Go backward through a given stack trace and flip flop instructions until you
# get a set of instructions that halts
function infinite_loop_fixer(original_machine::Assembly.MachineState, stack_trace)

    stack_trace = reverse(stack_trace)
    original_instructions = original_machine.instructions
    for idx in stack_trace
        new_instructions = original_instructions
        if isa(new_instructions[idx], Assembly.Noop)
            new_instructions[idx] = Assembly.Jump(new_instructions[idx].value)
        elseif isa(new_instructions[idx], Assembly.Jump)
            new_instructions[idx] = Assembly.Noop(new_instructions[idx].value)
        else
            continue
        end

        new_machine = Assembly.MachineState(new_instructions)

        accumulator, test_stack = infinite_loop_finder(new_machine)

        if isa(test_stack, Nothing)
            return accumulator
        end
    end

    return nothing

end

main()