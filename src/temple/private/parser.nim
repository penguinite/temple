import helpers

type
  TokenKind* = enum
    Block, # A static block of text.
    Colon, # Used for attributes.
    Symbol, # A command.
  
  Token* = object
    case kind*: TokenKind
    of Block, Symbol:
      inner*: string
    else: discard

  ASItem = object

  ASTree = object ## WIP

proc tokenize*(input: string): seq[Token] =
  ## Converts an input into a set of tokens.
  ## This is the first step in parsing, it tries to be as simple as possible.
  var
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
          result.add(Token(kind: Symbol, inner: tmp))
          tmp = ""
        # Just disable command mode...
        cmdMode = false
      of ':':
        # Check if tmp already has data stored, if so,
        # then add it to the tree and get ready to parse a new command.
        if not tmp.isEmptyOrWhitespace():
          result.add(Token(kind: Symbol, inner: tmp))
          tmp = ""
        result.add(Token(kind: Colon))
      of ' ':
        # Commands are space-separated, so, again, check if tmp
        # already has something and if it does then add it to the tree
        # and get ready to parse the next token
        if not tmp.isEmptyOrWhitespace():
          result.add(Token(kind: Symbol, inner: tmp))
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
          result.add(Token(kind: Block, inner: tmp))
          tmp = ""
        cmdMode = true
      of '\\': backslash = true # Basic backslash handling
      else:
        tmp.add(ch)
        discard

  # One last check to see if tmp has data in it.
  if not tmp.isEmptyOrWhitespace():
    case cmdMode
    of true: result.add(Token(kind: Symbol, inner: tmp))
    of false: result.add(Token(kind: Block, inner: tmp))
  
  return result

## WIP
proc lex*(set: seq[Token]): ASTree =
  ## This proc converts a simple sequence of tokens into an AST.
  ## This is the second stage of parsing.
  return

proc parse*(tree: ASTree, data: JsonNode): string =
  ## This proc parses the AST, and *finally* returns the templated data.
  ## This is the final stage of parsing.
  return