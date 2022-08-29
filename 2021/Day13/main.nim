import std/[sequtils, strutils, sugar, os]

proc parseInput(inputFile: string): (seq[(int,int)], seq[(bool, int)]) =
  let input = collect(newSeq):
    for line in inputFile.lines: line

  var instructions = false

  for line in input:
    if not instructions:
      if line.len == 0:
        instructions = true
      else:
        let values = line.split(",")
        result[0].add((values[0].parseInt(), values[1].parseInt()))
    else:
      result[1].add(('x' in line, line.split("=")[^1].parseInt()))

func doFold(paper: seq[(int,int)], steps: seq[(bool, int)]): (seq[(int,int)], seq[(bool, int)]) =
  let currentStep = steps[0]
  result[1] = steps[1 .. ^1]

  if currentStep[0]:
    for point in paper:
      if point[0] < currentStep[1]:
        if not (point in result[0]):
          result[0].add(point)
      else:
        let newPoint = (currentStep[1] - (point[0] - currentStep[1]), point[1])
        if not (newPoint in result[0]):
          result[0].add(newPoint)
  else:
    for point in paper:
      if point[1] < currentStep[1]:
        if not (point in result[0]):
          result[0].add(point)
      else:
        let newPoint = (point[0], currentStep[1] - (point[1] - currentStep[1]))
        if not (newPoint in result[0]):
          result[0].add(newPoint)

func completeFold(paper: (seq[(int,int)], seq[(bool, int)])): seq[(int,int)] =
  var mPaper = paper
  while mPaper[1].len > 0:
    mPaper = doFold(mPaper[0], mPaper[1])

  result = mPaper[0]

# This is absolutely the worst way to do this
proc printPaper(paper: seq[(int, int)]) =
  let xMax = max(mapIt(paper, it[0]))
  let yMax = max(mapIt(paper, it[1]))

  for ydx in 0 .. yMax:
    var line = ""
    for xdx in 0 .. xMax:
      if (xdx, ydx) in paper:
        line = line & "#"
      else:
        line = line & " "
    echo line

proc main(inputFile: string) =
  var paperState = parseInput(inputFile)
  paperState = doFold(paperState[0], paperState[1])
  echo paperState[0].len

  let finalState = completeFold(paperState)
  printPaper(finalState)

when is_main_module:
  main(paramStr(1))
