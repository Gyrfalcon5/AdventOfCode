import std/[strformat, sequtils, strutils, sugar, tables, os]

type
  OctopusRef = ref Octopus 
  Octopus = object of RootObj
    xPos: int
    yPos: int
    energy: int
    flashed: bool
    neighbors: seq[OctopusRef]

# Debugging :/
proc printMap(octopusMap: Table[(int, int), OctopusRef], gridSize: int) = 

  for rowIdx in 0 ..< gridSize:
    var rowStr = ""
    for colIdx in 0 ..< gridSize:
      rowStr = rowStr & &"{octopusMap[(colIdx, rowIdx)].energy} "
    echo rowStr
  echo ""

func initOctopus(x: int, y: int, energy: int): Octopus =
  result.xPos = x
  result.yPos = y
  result.energy = energy
  result.flashed = false
  result.neighbors = @[]

func newOctopus(x: int, y: int, energy: int): OctopusRef =
  new(result)
  result[] = initOctopus(x, y, energy) # DRY gang

proc energize(octopus: var OctopusRef): int =
  if not octopus.flashed:
    inc octopus.energy
  if octopus.energy > 9 and not octopus.flashed:
    octopus.flashed = true
    octopus.energy = 0
    result = 1
    for idx in 0 ..< octopus.neighbors.len:
      result = result + energize(octopus.neighbors[idx])
  else:
    result = 0

proc step(octopi: var Table[(int, int), OctopusRef]): int = 

  for (_, octopus) in mpairs(octopi):
    result = result + energize(octopus)

  # reset the octopi
  for (_, octopus) in mpairs(octopi):
    octopus.flashed = false

proc simulate(octopi: var Table[(int, int), OctopusRef], numSteps: int): int =

  for step in 1 .. numSteps:
    result = result + step(octopi)

proc synchronize(octopi: var Table[(int, int), OctopusRef]): int =
  
  var stepNum = 0
  while true: # is this bad?
    var numFlashes = step(octopi)
    inc stepNum
    if numFlashes == octopi.len:
      result = stepNum
      break

proc parseInput(inputFile: string): seq[seq[int]] =
  # I should really just make a "parse a grid of ints" library thing
  var input = collect(newSeq):
    for line in inputFile.lines: line

  for line in input:
    var row: seq[int]
    for character in line:
      row.add(parseInt("" & character))

    result.add(row) # idiomatic, I think

func gridToMap(grid: seq[seq[int]]): Table[(int, int), OctopusRef] =

  for rowIdx in 0 ..< grid.len:
    for colIdx in 0 ..< grid[rowIdx].len:
      result[(colIdx, rowIdx)] = newOctopus(colIdx, rowIdx, grid[rowIdx][colIdx])

func generateNeighbors(location: (int, int)): seq[(int, int)] =
  for xMod in -1 .. 1:
    for yMod in -1 .. 1:
      if yMod == 0 and xMod == 0:
        continue
      result.add((location[0] + xMod, location[1] + yMod))

func addMagic(octopusMap: var Table[(int, int), OctopusRef]) = 
  # Time for p o i n t e r s ? YES I FIGURED IT OUT
  for (pos, octopus) in mpairs(octopusMap):
    var neighbors = generateNeighbors(pos)
    for neighbor in neighbors:
      if neighbor in toSeq(octopusMap.keys()):
        octopus.neighbors.add(octopusMap[neighbor])

proc main(inputFile: string) =

  var octopusMap = gridToMap(parseInput(inputFile))
  octopusMap.addMagic()

  echo simulate(octopusMap, 100)

  octopusMap = gridToMap(parseInput(inputFile))
  octopusMap.addMagic()

  echo synchronize(octopusMap)

when is_main_module:
  main(paramStr(1)) # look at me, not recompiling when I change inputs