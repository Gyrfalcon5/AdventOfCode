module Assembly

# Make sure other things can use types
export Instruction, MachineState, Nop, Acc, Jmp

# Make sure other things can use methods
export parse_instruction, advance

# Make some fun types to define different instructions
abstract type Instruction end

# Make a type to define the state machine
struct MachineState
    instructions::Array{Instruction}
    instruction_pointer::Int64
    accumulator::Int64

    function MachineState(instructions::Array{Instruction})
        return new(instructions, 1, 0)
    end

    function MachineState(instructions::Array{Instruction}, instruction_pointer::Int64, accumulator::Int64)
        return new(instructions, instruction_pointer, accumulator)
    end
end

struct Noop <: Instruction 
    value::Int64
end

struct Accumulate <: Instruction
    value::Int64
end

struct Jump <: Instruction
    value::Int64
end

# How to convert from the input format to instructions we know of
function parse_instruction(input)::Instruction
    if input[1] == "nop"
        return Noop(parse(Int64, input[2]))
    elseif input[1] == "acc"
        return Accumulate(parse(Int64, input[2]))
    elseif input[1] == "jmp"
        return Jump(parse(Int64, input[2]))
    end
    throw(DomainError(input, "No recognizeable commands!"))
end

# Convenience function to execute the machine in it's current state
function advance(machine::MachineState)::MachineState
    return advance(machine, machine.instructions[machine.instruction_pointer])
end

# These functions define the changes to the machine state based on the instruction type
function advance(machine::MachineState, instruction::Noop)
    return MachineState(machine.instructions,
                        machine.instruction_pointer + 1,
                        machine.accumulator)
end

function advance(machine::MachineState, instruction::Jump)
    return MachineState(machine.instructions,
                        machine.instruction_pointer + instruction.value,
                        machine.accumulator)
end

function advance(machine::MachineState, instruction::Accumulate)
    return MachineState(machine.instructions,
                        machine.instruction_pointer + 1,
                        machine.accumulator + instruction.value)
end

# Check if the machine is complete
function complete(machine::MachineState)
    return machine.instruction_pointer > length(machine.instructions)
end

end