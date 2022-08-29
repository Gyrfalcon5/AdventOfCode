import sugar, std/[strformat, sequtils, strutils, math, enumerate]


type Board = object of RootObj
  numbers : array[0 .. 4, array[0 .. 4, int]]
  called : array[0 .. 4, array[0 .. 4, bool]]

proc markNumber(self: var Board, calledNumber: int) =
  for rowIdx, row in self.numbers:
    for colIdx, number in row:
      if number == calledNumber:
        self.called[rowIdx][colIdx] = true
        return

proc isWinning(self: Board): bool =
  
  for row in self.called:
    if all(row, proc(x : bool): bool = x):
      return true

  for colIdx in 0 ..< self.called.len:
    var column: seq[bool]
    for row in self.called:
      column.add(row[colIdx])
    
    if all(column, proc(x : bool): bool = x):
      return true

  return false

proc score(self: Board): int = 
  
  var score: int

  for rowIdx, row in self.called:
    for colIdx, called in row:
      if not called:
        score += self.numbers[rowIdx][colIdx]

  return score


proc parseCalledNumbers(fileName : string): seq[int] =
  var input: seq[string] = split(readLines(fileName, 1)[0], ",")
  return map(input, proc(x : string): int = parseInt(x))

proc parseBoards(fileName : string): seq[Board] =
  var input: seq[string] = collect(newSeq):
    for line in fileName.lines: line
  input = input[2 .. ^1]
  var boards: seq[Board]

  for startIdx in countup(0, input.len, 6):
    var newBoard: Board
    for rowIdx, inputIdx in enumerate(startIdx .. (startIdx + 4)):
      var values: seq[string] = split(input[inputIdx], " ")
      values = filter(values, proc(x : string): bool = x.len > 0)
      var intValues: seq[int] = map(values, proc(x : string): int = parseInt(x))
      for colIdx, value in intValues:
        newBoard.numbers[rowIdx][colIdx] = value

    boards.add(newBoard)

  return boards

proc playGame(calledNumbers: seq[int], boards: var seq[Board]): (int, int) =

  var firstScore: int
  var lastScore: int

  for calledNumber in calledNumbers:
    for boardIdx in 0 ..< boards.len:
      boards[boardIdx].markNumber(calledNumber)

    if firstScore == 0:
      for board in boards:
        if board.isWinning():
          firstScore = board.score() * calledNumber

    if firstScore != 0:
      if all(map(boards, isWinning), proc(x: bool): bool = x):
        lastScore = boards[0].score() * calledNumber
        return (firstScore, lastScore)
      else:
        boards = filter(boards, proc(x: Board): bool = not x.isWinning())

  return (0, 0)

  
proc main(inputFile: string) =
  var calledNumbers: seq[int] = parseCalledNumbers(inputFile)
  var boards: seq[Board] = parseBoards(inputFile)
  var firstScore: int
  var lastScore: int
  (firstScore, lastScore) = playGame(calledNumbers, boards)

  echo &"Score of the winning board is {firstScore}"

  echo &"Score of last to win board is {lastScore}"
  

when is_main_module:
  main("input.txt")

