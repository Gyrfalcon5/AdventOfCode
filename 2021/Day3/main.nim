import sugar, std/[strformat, sequtils, strutils, math]

proc getOnes(data: seq[string]): seq[int] =
  var ones: seq[int] = collect(newSeq):
    for idx in 1 .. data[0].len: 0

  for value in data:
    for index, digit in value:
      if digit == '1':
        inc ones[index]

  return ones

var input: seq[string] = split(readFile("input.txt"),  "\n")
input = input[0 .. ^2] # strip off trailing newline
var ones: seq[int] = getOnes(input)

var gamma: string = ""
var epsilon: string = ""

for value in ones:
  if value > (input.len div 2):
    gamma = gamma & "1"
    epsilon = epsilon & "0"
  else:
    gamma = gamma & "0"
    epsilon = epsilon & "1"


var product: int = parseBinInt(gamma)*parseBinInt(epsilon)

echo &"Gamma: {gamma}\nEpsilon: {epsilon}\nProduct: {product}"

var generator: seq[string] = input
var generatorOnes: seq[int] = ones
var compareIdx: int = 0

while generator.len > 1:
  if generatorOnes[compareIdx] >= int(ceil(generator.len / 2)):
    generator = filter(generator, proc(x: string): bool = x[compareIdx] == '1')
  else:
    generator = filter(generator, proc(x: string): bool = x[compareIdx] == '0')
  generatorOnes = getOnes(generator)
  inc compareIdx

var scrubber: seq[string] = input
var scrubberOnes: seq[int] = ones
compareIdx = 0

while scrubber.len > 1:
  if scrubberOnes[compareIdx] >= int(ceil(scrubber.len / 2)):
    scrubber = filter(scrubber, proc(x: string): bool = x[compareIdx] == '0')
  else:
    scrubber = filter(scrubber, proc(x: string): bool = x[compareIdx] == '1')
  scrubberOnes = getOnes(scrubber)
  inc compareIdx

var secondProduct: int = parseBinInt(generator[0])*parseBinInt(scrubber[0])

echo &"Generator: {generator[0]}\nScrubber: {scrubber[0]}\nProduct: {secondProduct}"