# temple

**Migration notice:** The git repository for this project has moved to [https://codeberg.org/onbox/temple](https://codeberg.org/onbox/temple), this link will still work but it will not contain any new updates. Documentation for this project is available at [https://docs.penguinite.dev/temple/](https://docs.penguinite.dev/temple/)

---

A simple templating library, temple was designed with ease of use and performance in mind.

Temple is perfect for the following use-cases:

- When you need a simple templating library with no macro fuss.
- When you need to template stuff at run-time (Fx. if you let the user replace assets at run-time)
- When you need a bit of magic such as conditionals and maybe attributes but nothing fancy.

*Note:* Do **NOT** run temple on untrusted input, as this wasn't designed with that in mind. This is meant for trustable input, such as a server's own template files, but not user input or anything manipulatable by a malicious actor.

## How to template

`$item$` to insert an item at that point.

Temple supports conditionals like so:

```
$if(item)$
Text to be added if $item$ exists.
$end$
```

And attributes:

```
$item[attribute]$
```

Currently, the following attributes are available:
1. `bold`: Adds `<strong>` tags around the text, thus making it bold.
2. `bold`: Adds `<em>` tags around the text, thus making it italic.
3. `list_by_comma`: Creates a list with a comma as the separator
4. `list_by_newline`: Creates a list with newlines as the separator
5. `span_separated`: Wraps every character with `<span>` tags around it.


Attributes sadly cannot be stacked, and if conditions do not support else blocks.
These are things that I've got to add in the future, but meanwhile, you can do the following to work around the lack of else blocks

```
$if(item)$
First condition, this will display if item exists
$end$

$if(!item)$
Second condition, this will display if item doesn't exist.
And it acts like an else block.
$end$
```

## How to use

Install temple by running `nimble install https://github.com/penguinite/pothole >= 0.2.3` and add it to your `.nimble` file like so:

```
requires "https://github.com/penguinite/temple.git >= 0.2.3"
```

And then, import `temple` as a module in whatever you want to use.

```nim
import temple
```

And whenever you want to template something, call the `templateify()` procedure like so:

```nim
templateify(
  templateString,
  templateData
)
```

templateString is just a string containing the actual template itself, like "&lt;h1&gt;\$name\$&lt;/h1&gt;"
templateData should be a Table consisting of only strings, where the key is the name of an item and the value is the data that that item should have.

Here is an example of a valid `templateify()` cal:

```nim
import temple, std/tables

templateify(
  """
$if(name)$
<h1>Hello $name$</h1>
$end$

$if(!name)$
<p>You have to insert a valid name.</p>
$end$
  """,
  {
    "name": "John",
  }.toTable
)
```
This will output "&lt;h1&gt;Hello John&lt;/h1&gt;"  but if the `name` key in the table was an empty string or if it didn't exist at all, then the output instead would have been "&lt;p&gt;You have to insert a valid name.&lt;/p&gt;"

<!--
TODO: Custom attributes
-->
