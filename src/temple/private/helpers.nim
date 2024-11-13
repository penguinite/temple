import std/json
export json

proc isEmptyOrWhitespace*(input: string, chset: set[char] = {' ', '\t', '\v', '\r', '\l', '\f'}): bool =
  for ch in input:
    if ch notin chset:
      return false
  return true

# We can't put the definition for TempleFailAction here since this is a private file. So we turned TFA into a number!
template handleError*(tfa: int, msg: string, pollute_msg: string, prefix = "Error whilst templating: ") =
  case failAction:
  of TFRaiseException: raise newException(ValueError, prefix & msg)
  of TFDoNothing: continue
  of TFPrintStderr: stderr.writeLine(prefix & msg)
  of TFPolluteOutput: result.add("\n" & prefix & pollute_msg & "\n")

proc isString*(n: JsonNode): bool =
  ## Returns whether or not a JsonNode *can* be converted into a string.
  ## Used in the final stage of templating, parsing the AST.
  case n.kind:
  of JString, JInt, JBool: return true
  else: return false

proc toString*(n: JsonNode): string =
  ## Converts a compatible JsonNode into a string.
  ## Used in the final stage of templating, parsing the AST.
  case n.kind:
  of JString: return n.getStr()
  of JInt: return $(n.getInt())
  of JBool: return $(n.getBool())
  else: raise newException(ValueError, "toString called on a value that can't return a string.")