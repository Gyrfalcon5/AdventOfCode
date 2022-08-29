import std/[strformat, sequtils, strutils, tables, hashes, math]

proc parseFile(fileName: string): seq[int] =
  var input: seq[string] = split(readLines(fileName, 1)[0], ",")
  return mapIt(input, parseInt(it))

func advanceDay(fishes: seq[int]): seq[int] =
  var oldFish, newFish: seq[int]
  for fish in fishes:
    if fish == 0:
      oldFish.add(6)
      newFish.add(8)
    else:
      oldFish.add(fish - 1)

  return oldFish & newFish

func fastAdvanceDay(fishes: CountTable[int]): CountTable[int] =
  var newFishes: CountTable[int]

  for (days, num) in pairs(fishes):
    if days == 0:
      if hasKey(newFishes, 6):
        newFishes[6] = newFishes[6] + num
      else:
        newFishes[6] = num

      newFishes[8] = num
    elif hasKey(newFishes, days - 1):
      newFishes[days - 1] = newFishes[days - 1] + num
    else:
      newFishes[days - 1] = num

  return newFishes

proc main(inputFile: string) =
  var fishes = parseFile(inputFile)

  for idx in 1 .. 80:
    fishes = advanceDay(fishes)

  echo &"The number of fish after 80 days is {fishes.len}"

  # Try again with something faster
  var fastFishes = toCountTable(parseFile(inputFile))

  for idx in 1 .. 256:
    fastFishes = fastAdvanceDay(fastFishes)

  echo &"The number of fish after 256 days is {sum(toSeq(fastFishes.values()))}"

when is_main_module:
  # main("test.txt")
  main("input.txt")
