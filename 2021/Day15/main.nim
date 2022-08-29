import std/[strformat, strutils, sugar, os]

proc parseInput(inputFile: string): seq[seq[int]] =
  var input = collect(newSeq):
    for line in inputFile.lines: line

  for line in input:
    var convertedLine: seq[int]
    for character in line:
      convertedLine.add(parseInt("" & character))
    result.add(convertedLine)

func makeMap(grid: seq[seq[int]]): seq[seq[int]] = 
  result = newSeq[seq[int]](grid.len)
  for idx in 0 ..< grid.len:
    result[idx] = newSeq[int](grid[idx].len)

  result[^1][^1] = grid[^1][^1]
  for cornerIdx in countdown(grid.len - 2, 0, 1):
    result[^1][cornerIdx] = result[^1][cornerIdx + 1] + grid[^1][cornerIdx]
    result[cornerIdx][^1] = result[cornerIdx + 1][^1] + grid[cornerIdx][^1]

    for vertIdx in countdown(grid.len - 2, cornerIdx + 1, 1):
      result[vertIdx][cornerIdx] = grid[vertIdx][cornerIdx] + 
                                   min(result[vertIdx + 1][cornerIdx],
                                       result[vertIdx][cornerIdx + 1])
    
    for horizIdx in countdown(grid.len - 2, cornerIdx + 1, 1):
      result[cornerIdx][horizIdx] = grid[cornerIdx][horizIdx] +
                                    min(result[cornerIdx + 1][horizIdx],
                                        result[cornerIdx][horizIdx + 1])
    
    result[cornerIdx][cornerIdx] = grid[cornerIdx][cornerIdx] +
                                   min(result[cornerIdx + 1][cornerIdx],
                                       result[cornerIdx][cornerIdx + 1])

# Debugging
proc printGrid(grid: seq[seq[int]]) =
  for row in grid:
    var printRow: string
    for num in row:
      printRow = printRow & &"{num} "
    echo printRow

func wrapAround(input, limit: int): int =
  result = input
  while result > limit:
    result = result - limit


func enlargeMap(grid: seq[seq[int]]): seq[seq[int]] = 
  result = newSeq[seq[int]](grid.len * 5)
  for idx in 0 ..< result.len:
    result[idx] = newSeq[int](grid.len * 5)

  for xQuad in 0 .. 4:
    let xOffset = xQuad * grid.len
    for yQuad in 0 .. 4:
      let yOffset = yQuad * grid.len

      for xdx in 0 ..< grid.len:
        for ydx in 0 ..< grid.len:
          result[ydx + yOffset][xdx + xOffset] = wrapAround(grid[ydx][xdx] + yQuad + xQuad, 9)

proc main(inputFile: string) =
  let baseGrid = parseInput(inputFile)
  let mapGrid = makeMap(baseGrid)
  echo mapGrid[0][0] - baseGrid[0][0]

  # This gives a too high result with my input,
  # but not the example, can't figure out why
  let bigGrid = enlargeMap(baseGrid)
  let bigMap = makeMap(bigGrid)
  echo bigMap[0][0] - bigGrid[0][0]


when is_main_module:
  main(paramStr(1))