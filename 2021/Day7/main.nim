import std/[strformat, sequtils, strutils, math]

proc parseFile(fileName: string): seq[int] =
  var input: seq[string] = split(readLines(fileName, 1)[0], ",")
  return mapIt(input, parseInt(it))

func totalDist(positions: seq[int], destination: int): int =
  return sum(mapIt(positions, abs(it - destination)))

func fuelBurn(distance: int): int = 
  return sum(toSeq(1 .. distance))

func totalDist2(positions: seq[int], destination: int): int =
  return sum(mapIt(positions, fuelBurn(abs(it - destination))))

proc main(inputFile: string) =
  var crabs: seq[int] = parseFile(inputFile)

  var minDistance: int = 999_999_999
  var minDistancePos: int

  for pos in min(crabs) .. max(crabs):
    var currDist: int = totalDist(crabs, pos)
    if currDist < minDistance:
      minDistance = currDist
      minDistancePos = pos

  echo &"The minimum fuel needed is {minDistance}"

  minDistance = 999_999_999
  minDistancePos = 0

  for pos in min(crabs) .. max(crabs):
    var currDist: int = totalDist2(crabs, pos)
    if currDist < minDistance:
      minDistance = currDist
      minDistancePos = pos

  echo &"The minimum fuel needed is {minDistance}"

when is_main_module:
  # main("test.txt")
  main("input.txt")