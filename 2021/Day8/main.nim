import std/[strformat, sequtils, strutils, sugar, tables, math]

proc strToSet(input: string): set[char] = 
  var output: set[char]

  for character in input:
    incl(output, {character})

  return output

proc parseFile(inputFile: string): seq[(seq[set[char]], seq[set[char]])] =
  var input: seq[string] = collect(newSeq):
    for line in inputFile.lines: line

  var output: seq[(seq[set[char]], seq[set[char]])]

  for line in input:

    var left, right: string
    (left, right) = split(line, " | ")

    output.add((mapIt(split(left, " "), strToSet(it)), 
                mapIt(split(right, " "), strToSet(it))))

  return output

func countUniques(data: seq[(seq[set[char]], seq[set[char]])]): int = 
  var totalUniques: int
  for line in data:
    for display in line[1]:
      if display.len == 2 or 
         display.len == 3 or 
         display.len == 4 or 
         display.len == 7:
        inc totalUniques

  return totalUniques

proc solveLine(samples: seq[set[char]], display: seq[set[char]]): int =
  var mapping_from_display: Table[set[char], int]
  var mapping_to_display: Table[int, set[char]]

  # mark the ones we know based on length
  for sample in samples:
    if sample.len == 2:
      mapping_from_display[sample] = 1
      mapping_to_display[1] = sample
    elif sample.len == 3:
      mapping_from_display[sample] = 7
      mapping_to_display[7] = sample
    elif sample.len == 4:
      mapping_from_display[sample] = 4
      mapping_to_display[4] = sample
    elif sample.len == 7:
      mapping_from_display[sample] = 8
      mapping_to_display[8] = sample

  # 9 must be length of 6 and contain all segments of 4
  for sample in samples:
    if sample.len == 6 and
       mapping_to_display[4] < sample:
      mapping_to_display[9] = sample
      mapping_from_display[sample] = 9
      break

  # 6 is length of 6 and but does not contain 1
  for sample in samples:
    if sample.len == 6 and
       not (mapping_to_display[1] < sample):
      mapping_to_display[6] = sample
      mapping_from_display[sample] = 6
      break

  # 0 is of length 6 and is not 9 or 6
  for sample in samples:
    if sample.len == 6 and
       not (sample == mapping_to_display[9]) and
       not (sample == mapping_to_display[6]):
      mapping_to_display[0] = sample
      mapping_from_display[sample] = 0
      break

  # 3 is the only one of length 5 to contain 1
  for sample in samples:
    if sample.len == 5 and
       mapping_to_display[1] < sample:
      mapping_to_display[3] = sample
      mapping_from_display[sample] = 3
      break

  # 5 is the only one of length 5 to be a subset of 6
  for sample in samples:
    if sample.len == 5 and
       sample < mapping_to_display[6]:
      mapping_to_display[5] = sample
      mapping_from_display[sample] = 5
      break

  # 2 is the only one left!
  for sample in samples:
    if sample.len == 5 and
        not (sample == mapping_to_display[3]) and
        not (sample == mapping_to_display[5]):
      mapping_to_display[2] = sample
      mapping_from_display[sample] = 2
  
  return 1000 * mapping_from_display[display[0]] +
          100 * mapping_from_display[display[1]] +
           10 * mapping_from_display[display[2]] +
            1 * mapping_from_display[display[3]]

proc main(inputFile: string) =
  
  var data = parseFile(inputFile)

  var numUniques = countUniques(data)

  echo &"The number of unique patterns displayed is {numUniques}"

  var displaySum = sum(mapIt(data, solveLine(it[0], it[1])))

  echo &"The sum total of the displays is {displaySum}"
  

when is_main_module:
  # main("test.txt")
  main("input.txt")