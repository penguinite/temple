import helpers

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

  ASTNodeKind = enum
    Block, # A static block of text
    Item, # A basic string substitution
    Conditional, # A conditional
    Loop, # A loop
    Attribute, # An attribute

  ASTNode = object
    case kind*: ASTNodeKind
    of Block, Item: inner*: string
    of Attribute: attr*: string
    of Conditional:
      condition*: string
      pass*: seq[ASTNode]
      otherwise*: seq[ASTNode]
    of Loop:
      item*: string
      contents*: seq[ASTNode]

  AST = seq[ASTNode]

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
proc lex*(tokenSet: seq[Token]): AST =
  ## This proc converts a simple sequence of tokens into an AST.
  ## This is the second stage of parsing.
  var
    depth = 0
    curSet: seq[ASTNode]
    
  for token in tokenSet:
    case token.kind:
    of Block:
      curSet.add(ASTNode(kind: Block, inner: token.inner))
    of Symbol:
      case token.inner:
      of "if":
        
        if depth == 0
      of "end":
      else:
        curSet.add(ASTNode(kind: Item, inner: token.inner))
    else:
      echo "Help"


  return

proc parse*(tree: AST, data: JsonNode): string =
  ## This proc parses the AST, and *finally* returns the templated data.
  ## This is the final stage of parsing.
  return "Help"