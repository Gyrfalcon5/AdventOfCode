import sugar, std/[strformat, sequtils, strutils, tables, hashes]

type Point = object of RootObj
  x: int
  y: int

func initPoint(x: int, y: int): Point =
  result.x = x
  result.y = y

func hash(x: Point): Hash =
  return !$(hash(x.x) !& hash(x.y))

func generateLine(point1: Point,
                  point2: Point,
                  diag: bool): seq[Point] =
  var line: seq[Point]
  if point1.x == point2.x:
    if point1.y < point2.y:
      for ydx in point1.y .. point2.y:
        line.add(initPoint(point1.x, ydx))
    else:
      for ydx in point2.y .. point1.y:
        line.add(initPoint(point1.x, ydx))

  elif point1.y == point2.y:
    if point1.x < point2.x:
      for xdx in point1.x .. point2.x:
        line.add(initPoint(xdx, point1.y))
    else:
      for xdx in point2.x .. point1.x:
        line.add(initPoint(xdx, point1.y))

  elif diag:
    # bottom left to top right
    if point1.x < point2.x and point1.y < point2.y:
      for (xdx, ydx) in zip(toSeq(countup(point1.x, point2.x, 1)),
                            toSeq(countup(point1.y, point2.y, 1))):
        line.add(initPoint(xdx, ydx))
    # bottom right to top left
    elif point1.x > point2.x and point1.y < point2.y:
      for (xdx, ydx) in zip(toSeq(countdown(point1.x, point2.x, 1)),
                            toSeq(countup(point1.y, point2.y, 1))):
        line.add(initPoint(xdx, ydx))
    # top left to bottom right
    elif point1.x < point2.x and point1.y > point2.y:
      for (xdx, ydx) in zip(toSeq(countup(point1.x, point2.x, 1)),
                            toSeq(countdown(point1.y, point2.y, 1))):
        line.add(initPoint(xdx, ydx))
    # top right to bottom left
    elif point1.x > point2.x and point1.y > point2.y:
      for (xdx, ydx) in zip(toSeq(countdown(point1.x, point2.x, 1)),
                            toSeq(countdown(point1.y, point2.y, 1))):
        line.add(initPoint(xdx, ydx))


  return line

proc parseInput(inputFile: string): seq[(Point, Point)] =
  var input: seq[string] = collect(newSeq):
    for line in inputFile.lines: line

  var points: seq[(Point, Point)]
  for line in input:
    var splitLine: seq[string] = split(line, " -> ")
    var leftSplit: seq[int] = map(split(splitLine[0], ","),
                                  (x: string) => parseInt(x))
    var rightSplit: seq[int] = map(split(splitLine[1], ","),
                                  (x: string) => parseInt(x))

    points.add((initPoint(leftSplit[0], leftSplit[1]),
                initPoint(rightSplit[0], rightSplit[1])))

  return points

proc main(inputFile: string) =
  var lines: seq[(Point, Point)] = parseInput(inputFile)
  var points: seq[Point]

  for line in lines:
    points = concat(points, generateLine(line[0], line[1], false))

  var countPoints = toCountTable(points)
  sort(countPoints)

  var numDangers: int
  for point, count in pairs(countPoints):
    if count > 1:
      inc numDangers

  echo &"The number of dangerous points is {numDangers}"

  points = @[]
  numDangers = 0

  for line in lines:
    points = concat(points, generateLine(line[0], line[1], true))

  countPoints = toCountTable(points)
  sort(countPoints)

  for point, count in pairs(countPoints):
    if count > 1:
      inc numDangers

  echo &"The number of diagonally dangerous points is {numDangers}"

when is_main_module:
  main("test.txt")
  main("input.txt")
