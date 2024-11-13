import temple/private/parser, std/json

type
  TempleFailAction* = enum
    TFRaiseException = 0, TFPrintStderr = 1, TFPolluteOutput = 2, TFDoNothing = 3

proc templateify*(input: string, data: JsonNode, failAction = TFRaiseException): string =
  # First pass. Converting the input data into a basic set of tokens.
  # This set will be parsed more and more as we go on.
  # And this is just the starting point
  when not defined(templeDebug):
    # I wish my life could be as harmonious as this one-liner
    # Note: It's only harmonious on the surface. Don't dive deep into temple/private/parser
    return tokenize(input).lex().parse(data) 
  else:
    let tokens = tokenize(input)
    echo "lex() output:"
    for token in tokens:
      echo "type: ", token.kind
      case token.kind:
      of Block, Symbol:
        echo "inner: ", token.inner
      else: discard
    echo "---"

    let tree = lex(tokens)

echo "Output: ", templateify("Hello $name$!", %* {"name": "John"})