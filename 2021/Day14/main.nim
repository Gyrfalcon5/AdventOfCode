import std/[sequtils, strutils, sugar, os, tables, algorithm, math]

proc parseInput(inputFile: string): (string, Table[string, string]) =
  var input = collect(newSeq):
    for line in inputFile.lines: line

  result[0] = input[0]
  input = input[2 .. ^1]

  for line in input:
    let splitLine = line.split(" -> ")
    result[1][splitLine[0]] = splitLine[1]

func polymerize(polyTemplate: string, rules: Table[string, string]): string = 
  for idx in 0 .. polyTemplate.len - 2:
    result = result & 
             polyTemplate[idx] & 
             rules.getOrDefault(polyTemplate[idx .. idx + 1], "")
  result = result & polyTemplate[^1]

func makePolymer(polyTemplate: string, rules: Table[string, string], numIters: int): string =
  result = polyTemplate
  for iter in 1 .. numIters:
    result = polymerize(result, rules)

func analyzePolymer(polymer: string): int =
  var analysis = polymer.toCountTable()
  analysis.sort()
  result = analysis.values().toSeq()[0] - analysis.values().toSeq()[^1]

# I think this is a great joke
func toPairymer(polymer: string): CountTable[string] = 
  for idx in 0 .. polymer.len - 2:
    let pair = polymer[idx .. idx + 1]
    result[pair] = result.getOrDefault(pair, 0) + 1

func pairymerize(pairymer: CountTable[string], 
                 rules: Table[string, string]): CountTable[string] =
  for (pair, num) in pairs(pairymer):
    let ruleOutput = rules[pair]
    let pair1 = pair[0] & ruleOutput
    let pair2 = ruleOutput & pair[1]
    result[pair1] = result.getOrDefault(pair1, 0) + num
    result[pair2] = result.getOrDefault(pair2, 0) + num

func makePairymer(pairymer: CountTable[string], 
                  rules: Table[string, string], 
                  numIters: int): CountTable[string] =
  result = pairymer
  for iter in 1 .. numIters:
    result = pairymerize(result, rules)

func analyzePairymer(pairymer: CountTable[string]): int =
  var letterCounts: CountTable[char]
  for (pair, num) in pairs(pairymer):
    letterCounts[pair[0]] = letterCounts.getOrDefault(pair[0], 0) + num
    letterCounts[pair[1]] = letterCounts.getOrDefault(pair[1], 0) + num
  # This may be off by one but you can always guess lmao
  result = int(round((letterCounts.largest()[1] - letterCounts.smallest()[1]) / 2))

proc main(inputFile: string) =
  var (polymer, rules) = parseInput(inputFile) # Oh, so I can do that
  polymer = makePolymer(polymer, rules, 10)
  echo analyzePolymer(polymer)

  var pairymer = polymer.toPairymer() # Not wasting those iterations!
  pairymer = makePairymer(pairymer, rules, 30)
  echo pairymer.analyzePairymer()

when is_main_module:
  main(paramStr(1))