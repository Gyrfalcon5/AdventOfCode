import std/[strformat, sequtils, strutils, sugar, tables, algorithm]

proc parseFile(inputFile: string): seq[string] = 
  return collect(newSeq):
    for line in inputFile.lines: line

func findIllegalCharacter(line: string): seq[char] = 
  var stack: seq[char]

  var opens = @['[', '{', '(', '<']
  var closes = @[']', '}', ')', '>']
  var openToClose = {'[' : ']',
                       '{' : '}',
                       '(' : ')',
                       '<' : '>'}.toTable()

  for character in line:
    if character in opens:
      stack.add(open_to_close[character])
    if character in closes:
      if character != stack[^1]:
        return @[character]
      else:
        stack = stack[0 .. ^2]

  return stack & @[' ']

func scoreErrors(errors: seq[char]): int = 
  var errorToValue = {')' : 3,
                      ']' : 57,
                      '}' : 1197,
                      '>' : 25137}.toTable()

  var score: int
  for error in errors:
    score = score + errorToValue[error]

  return score

func scoreCompletions(completion: seq[char]): int =
  var completionToValue = {')' : 1,
                           ']' : 2,
                           '}' : 3,
                           '>' : 4}.toTable()

  var score: int
  for idx in countdown(completion.len - 1, 0, 1):
    score = score * 5 + completionToValue[completion[idx]]

  return score

proc main(inputFile: string) =
  var lines = parseFile(inputFile)

  var syntaxChecking = mapIt(lines, findIllegalCharacter(it))
  var illegalCharactersSeq = filterIt(syntaxChecking, it[^1] != ' ')

  # There must be a better way to do this but oh well
  var illegalCharacters: seq[char]
  for list in illegalCharactersSeq:
    illegalCharacters.add(list[0])
  
  echo &"The total syntax error score is {scoreErrors(illegalCharacters)}"

  var lineCompletions = filterIt(syntaxChecking, it[^1] == ' ')
  applyIt(lineCompletions, it[0 .. ^2])
  var completionScores = mapIt(lineCompletions, scoreCompletions(it))
  sort(completionScores)

  echo &"The middle line completion scroe is {completionScores[completionScores.len div 2]}"

when is_main_module:
  # main("test.txt")
  main("input.txt")