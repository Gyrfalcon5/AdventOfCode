import std/[strformat, sequtils, strutils, sugar, math, tables, algorithm]

proc parseFile(inputFile: string): seq[seq[int]] =
  var input: seq[string] = collect(newSeq):
    for line in inputFile.lines: line

  var output: seq[seq[int]]

  for line in input:
    output.add(mapIt(line, parseInt("" & it))) # gotta be a string

  return output

# Do this in a way I should have done everything before lol
func gridToTable(grid: seq[seq[int]]): Table[(int,int), int] =
  var mapping: Table[(int, int), int]

  for rowIdx in 0 ..< grid.len:
    for colIdx in 0 ..< grid[rowIdx].len:
      mapping[(rowIdx, colIdx)] = grid[rowIdx][colIdx]

  return mapping

func sizeBasin(mapping: Table[(int, int), int], lowPoint: (int, int)): int =

  var basin: seq[(int, int)]
  basin.add(lowPoint)
  var numAdded: int = 1 # How many points we have added this round

  while numAdded != 0:
    numAdded = 0
    var newPoints: seq[(int, int)]
    for point in basin:
      if mapping.hasKey((point[0], point[1] + 1)) and
         mapping[(point[0], point[1] + 1)] < 9 and
         not ((point[0], point[1] + 1) in basin) and
         not ((point[0], point[1] + 1) in newPoints):
        inc numAdded
        newPoints.add((point[0], point[1] + 1))
      
      if mapping.hasKey((point[0], point[1] - 1)) and
         mapping[(point[0], point[1] - 1)] < 9 and
         not ((point[0], point[1] - 1) in basin) and
         not ((point[0], point[1] - 1) in newPoints):
        inc numAdded
        newPoints.add((point[0], point[1] - 1))

      if mapping.hasKey((point[0] + 1, point[1])) and
         mapping[(point[0] + 1, point[1])] < 9 and
         not ((point[0] + 1, point[1]) in basin) and
         not ((point[0] + 1, point[1]) in newPoints):
        inc numAdded
        newPoints.add((point[0] + 1, point[1]))
      
      if mapping.hasKey((point[0] - 1, point[1])) and
         mapping[(point[0] - 1, point[1])] < 9 and
         not ((point[0] - 1, point[1]) in basin) and
         not ((point[0] - 1, point[1]) in newPoints):
        inc numAdded
        newPoints.add((point[0] - 1, point[1]))

    basin = basin & newPoints

  return basin.len

# Convenience to see the grid
proc printGrid(grid: seq[seq[int]]) =
  for row in grid:
    var line = ""
    for num in row[0 .. ^2]:
      line = line & &"{num}, "
    line = line & &"{row[^1]}"
    echo line

proc findLowPoints(grid: seq[seq[int]]): (seq[int], seq[(int,int)]) = 

  # Doing this the naive way, *gulp*
  var values: seq[int]
  var positions: seq[(int, int)]
  
  # Start with corners, top left
  if grid[0][0] < grid[0][1] and grid[0][0] < grid[1][0]:
    values.add(grid[0][0])
    positions.add((0, 0))
  # bottom left
  if grid[^1][0] < grid[^1][1] and grid[^1][0] < grid[^2][0]:
    values.add(grid[^1][0])
    positions.add((grid.len - 1, 0))
  # bottom right
  if grid[^1][^1] < grid[^1][^2] and grid[^1][^1] < grid[^2][^1]:
    values.add(grid[^1][^1])
    positions.add((grid.len - 1, grid[^1].len - 1))
  # top right
  if grid[0][^1] < grid[0][^2] and grid[0][^1] < grid[1][^1]:
    values.add(grid[0][^1])
    positions.add((0, grid[0].len - 1))

  # Next do top row
  for colIdx in 1 .. (grid[0].len - 2):
    if grid[0][colIdx] < grid[0][colIdx - 1] and
       grid[0][colIdx] < grid[0][colIdx + 1] and
       grid[0][colIdx] < grid[1][colIdx]:
      values.add(grid[0][colIdx])
      positions.add((0, colIdx))

  # bottom row
  for colIdx in 1 .. (grid[^1].len - 2):
    if grid[^1][colIdx] < grid[^1][colIdx - 1] and
       grid[^1][colIdx] < grid[^1][colIdx + 1] and
       grid[^1][colIdx] < grid[^2][colIdx]:
      values.add(grid[^1][colIdx])
      positions.add((grid.len - 1, colIdx))

  # left edge
  for rowIdx in 1 .. (grid.len - 2):
    if grid[rowIdx][0] < grid[rowIdx + 1][0] and
       grid[rowIdx][0] < grid[rowIdx - 1][0] and
       grid[rowIdx][0] < grid[rowIdx][1]:
      values.add(grid[rowIdx][0])
      positions.add((rowIdx, 0))

  # right edge
  for rowIdx in 1 .. (grid.len - 2):
    if grid[rowIdx][^1] < grid[rowIdx + 1][^1] and
       grid[rowIdx][^1] < grid[rowIdx - 1][^1] and
       grid[rowIdx][^1] < grid[rowIdx][^2]:
      values.add(grid[rowIdx][^1])
      positions.add((rowIdx, grid[rowIdx].len - 1))

  # now the regular case
  for rowIdx in 1 .. (grid.len - 2):
    for colIdx in 1 .. (grid[rowIdx].len - 2):
      if grid[rowIdx][colIdx] < grid[rowIdx + 1][colIdx] and
         grid[rowIdx][colIdx] < grid[rowIdx - 1][colIdx] and
         grid[rowIdx][colIdx] < grid[rowIdx][colIdx + 1] and
         grid[rowIdx][colIdx] < grid[rowIdx][colIdx - 1]:
        values.add(grid[rowIdx][colIdx])
        positions.add((rowIdx, colIdx))

  return (values, positions)

func totalDanger(lowPoints: seq[int]): int =
  return sum(lowPoints) + lowPoints.len


proc main(inputFile: string) =
  var grid = parseFile(inputFile)
  var lowPoints = findLowPoints(grid)
  
  echo &"The total danger is {totalDanger(lowPoints[0])}"

  var mapping = gridToTable(grid)

  var basins = mapIt(lowPoints[1], sizeBasin(mapping, it))
  sort(basins)

  var danger = basins[^1] * basins[^2] * basins[^3]

  echo &"The basin factor is {danger}"
  

when is_main_module:
  # main("test.txt")
  main("input.txt")