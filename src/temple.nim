import std/[json, strutils]

const safeMode = false

const data = %* {
  "name": "John"
}

const input = """
Hello \$name\$!
"""

# First pass. Converting the input data into a basic set of tokens.
# This set will be parsed more and more as we go on.
# And this is just the starting point
type
  TokenKind = enum
    Block, # A static block of text.
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

for ch in input:
  if backslash:
    tmp.add(ch)
    backslash = false
    continue

  case cmdMode:
  of true:
    case ch:
    of '$':
      # Check if tmp already has data stored, and if so then add it to the tree.
      if not tmp.isEmptyOrWhitespace():
        tokenTree.add(Token(kind: Symbol, inner: tmp))
        tmp = ""
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
    of '\\': backslash = true # Basic backslash handling
    else:
      # Just add whatever we find to the tmp var.
      # It'll be sorted out eventually...
      tmp.add(ch)
  of false:
    case ch:
    of '$':
      # Check if tmp has something in it
      # if it does then add it to the tree
      if not tmp.isEmptyOrWhitespace():
        tokenTree.add(Token(kind: Block, inner: tmp))
        tmp = ""
      cmdMode = true
    of '\\': backslash = true # Basic backslash handling
    else:
      tmp.add(ch)
      discard

# One last check to see if tmp has data in it.
if not tmp.isEmptyOrWhitespace():
  case cmdMode
  of true: tokenTree.add(Token(kind: Symbol, inner: tmp))
  of false: tokenTree.add(Token(kind: Block, inner: tmp))

when defined(templeDebug):
  for token in tokenTree:
    echo "type: ", token.kind
    case token.kind:
    of Block, Symbol:
      echo "inner: ", token.inner
    else: discard

var
  output = ""
  i = -1

proc getUntilEnd*(tree: seq[tokenTree], pointer: int): seq[TokenTree] =

  
for token in tokenTree:
  inc i
  case token.kind:
  of Block:
    output.add(token.inner)
  of Symbol:
    case token.inner
    of "if", "for", "end": continue
    else:
      # Simple key
      if "." notin token.inner:
        continue

      # If the key is an "Array" then it must be
      # accessible through loops.
      if 

      # Advanced "Object" key
      if data.hasKey()


proc templateify*(input: string, data: JsonNode): string =
  return