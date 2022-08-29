import std/strutils, std/strformat, std/sequtils

var input: seq[string] = strutils.split(readFile("input.txt"),  "\n")
var directions: seq[string] = @[]
var distances: seq[int] = @[]

for line in input[0 .. ^2]:
    directions.add(strutils.split(strutils.strip(line), ' ')[0])
    distances.add(parseInt(strutils.split(strutils.strip(line), ' ')[1]))

var position: int = 0
var depth: int = 0

for command in sequtils.zip(directions, distances):
    if command[0] == "forward":
        position += command[1]
    elif command[0] == "down":
        depth += command[1]
    elif command[0] == "up":
        depth -= command[1]
    else:
        echo "AAAAAA"

echo &"Depth: {depth}\nPosition: {position}\nProduct: {depth*position}\n"

position = 0
depth = 0
var aim: int = 0

for command in sequtils.zip(directions, distances):
    if command[0] == "forward":
        position += command[1]
        depth += aim * command[1]
    elif command[0] == "down":
        aim += command[1]
    elif command[0] == "up":
        aim -= command[1]
    else:
        echo "AAAAAA"

echo &"Depth: {depth}\nPosition: {position}\nProduct: {depth*position}\n"