import strutils, std/strformat

var input: seq[string] = strutils.split(readFile("input.txt"),  "\n")
var clean_input: seq[int] = @[]

for value in input[0 .. ^2]:
    clean_input.add(parseInt(strutils.strip(value)))


var previous: int = clean_input[0]
var increases: int = 0

for value in clean_input[1 .. ^1]:
    if value > previous:
        inc increases
    previous = value

echo &"The number of increases is {increases}"

var summed_increases: int = 0

for idx in 3 ..< clean_input.len:
    if clean_input[idx] > clean_input[idx - 3]:
        inc summed_increases

echo &"The number of summed increases is {summed_increases}"