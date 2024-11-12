import std/[json, strutils]

const data = """
Hello $name$!
"""

# First pass. Converting the input data into a basic set of tokens.
# This set will be parsed more and more as we go on.
# And this is just the starting point
type
  TokenKind = enum
    Block, # A static block of text.
    DollarSign, # Command start/end symbol
    Colon, # Used for attributes.
    Symbol, # A command.
  
  Token = object
    case kind*: TokenKind
    of Block, Symbol:
      inner*: string
    else: discard

# Basic lexer/tokenizer
var
  tokenTree: seq[Token] = @[]
  backslash, cmdMode = false
  tmp = ""

for ch in data:
  case cmdMode:
  of true:
    case ch:
    of '$':
      # Just disable command mode...
      cmdMode = false
    of ':':
      # Check if tmp already has data stored, if so,
      # then add it to the tree and get ready to parse a new command.
      if not tmp.isEmptyOrWhitespace():
        tokenTree.add(Token(kind: Symbol, inner: tmp))
        tmp = ""
      tokenTree.add(Token(kind: Colon))
    of ' ':
      # Commands are space-separated, so, again, check if tmp
      # already has something and if it does then add it to the tree
      # and get ready to parse the next token
      if not tmp.isEmptyOrWhitespace():
        tokenTree.add(Token(kind: Symbol, inner: tmp))
        tmp = ""
    else:
      # Just 
      tmp.add(ch)

  of false
    case ch:
    of '$':

when defined(templeDebug):
  for token in tokenTree:
    echo "type: ", token.kind
    case token.kind:
    of Block, Symbol:
      echo "inner: ", token.inner



proc templateify*(input: string, data: JsonNode): string =
  return