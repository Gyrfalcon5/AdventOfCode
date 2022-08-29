import std/[sequtils, strutils, sugar, os, tables, algorithm, math]

type
  Packet = ref object of RootObj
    version: int
    packetType: int

  LiteralPacket = ref object of Packet
    value: int
    

func hexToByte(hex: char): string = 
  let hexTable = {'0' : "0000",
                  '1' : "0001",
                  '2' : "0010",
                  '3' : "0011",
                  '4' : "0100",
                  '5' : "0101",
                  '6' : "0110",
                  '7' : "0111",
                  '8' : "1000",
                  '9' : "1001",
                  'A' : "1010",
                  'B' : "1011",
                  'C' : "1100",
                  'D' : "1101",
                  'E' : "1110",
                  'F' : "1111"}.toTable()

  result = hexTable[hex]

proc newLiteralPacket(input: string): LiteralPacket =
  new result
  result.version = parseBinInt(input[0..2])
  result.packetType = parseBinInt(input[3 .. 5])
  
  let rawValue = input[6 .. ^1]
  var parsedValue = ""
  for idx in countup(0, len(rawValue), 5):
    parsedValue = parsedValue & rawValue[idx + 1 .. idx + 4]
    if rawValue[idx] == '0':
      break
  result.value = parseBinInt(parsedValue)

proc parseFile(inputFile: string): Packet =
  let input = collect(newSeq):
    for line in inputFile.lines: line

  var parsedBin = ""
  for digit in input[0]:
    parsedBin = parsedBin & hexToByte(digit)

  if parsedBin[3 .. 5] == "100": # LiteralPacket
    return newLiteralPacket(parsedBin)


proc main(inputFile: string) =
  var thing = parseFile(inputFile)

  if thing.packetType == 4:
    echo LiteralPacket(thing).value

when is_main_module:
  for idx in 1 .. paramCount():
    main(paramStr(idx))