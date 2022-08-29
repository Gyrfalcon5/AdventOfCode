import std/[sequtils, strutils, sugar, tables, os, sets]

# Well now I'm glad I learned to use refs!
type
  CaveRef = ref Cave
  Cave = object of RootObj
    name: string
    isLower: bool
    neighbors: seq[CaveRef]

func initCave(name: string): Cave =
  result.name = name
  if name.toLower() == name:
    result.isLower = true
  result.neighbors = @[]

func newCave(name: string): CaveRef =
  new(result)
  result[] = initCave(name)

proc createGraph(left, right: Table[string, seq[string]]): CaveRef =
  let nodeNames = toHashSet(toSeq(left.keys()) & toSeq(right.keys()))
  var nodeTable: Table[string, CaveRef]

  for name in nodeNames:
    nodeTable[name] = newCave(name)

  for name in nodeNames:
    if left.hasKey(name):
      for neighborName in left[name]:
        nodeTable[name].neighbors.add(nodeTable[neighborName])
    if right.hasKey(name):
      for neighborName in right[name]:
        nodeTable[name].neighbors.add(nodeTable[neighborName])

  result = nodeTable["start"]

proc parseInput(inputFile: string): CaveRef =
  var input = collect(newSeq):
    for line in inputFile.lines: line

  var leftToRight: Table[string, seq[string]]
  var rightToLeft: Table[string, seq[string]]
  for line in input:
    var sides = line.split("-")
    if leftToRight.hasKey(sides[0]):
      leftToRight[sides[0]].add(sides[1])
    else:
      leftToRight[sides[0]] = @[sides[1]]

    if rightToLeft.hasKey(sides[1]):
      rightToLeft[sides[1]].add(sides[0])
    else:
      rightToLeft[sides[1]] = @[sides[0]]

  result = createGraph(leftToRight, rightToLeft)

proc delve(root: CaveRef, path: seq[string]): seq[seq[string]] =
  if root.name == "end":
    result = @[path & @[root.name]]
  elif root.isLower and root.name in path:
    result = @[]
  else:
    result = concat(mapIt(root.neighbors, delve(it, path & @[root.name])))

proc delveDeeper(root: CaveRef, path: seq[string]): seq[seq[string]] =
  if root.name == "end":
    result = @[path & @[root.name]]
  elif root.name == "start" and path.len > 0:
    result = @[]
  elif root.isLower:
    var lowerCounts = filterIt(path, it == it.toLower()).toCountTable()
    if lowerCounts.getOrDefault(root.name, 0) > 1:
      result = @[]
    elif lowerCounts.getOrDefault(root.name, 0) > 0 and
         anyIt(lowerCounts.values().toSeq(), it > 1):
      result = @[]
    else:
      result = concat(mapIt(root.neighbors, delveDeeper(it, path & @[root.name])))
  else:
    result = concat(mapIt(root.neighbors, delveDeeper(it, path & @[root.name])))

proc main(inputFile: string) =
  var rootCave = parseInput(inputFile)
  var paths = delve(rootCave, @[])
  echo paths.len
  var deepPaths = delveDeeper(rootCave, @[])
  echo deepPaths.len

when is_main_module:
  main(paramStr(1))
