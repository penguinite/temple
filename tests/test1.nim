import temple, std/json

assert templateify("Hello $name$", %* {"name": "John"}) == "Hello John"
