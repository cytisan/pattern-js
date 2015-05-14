# pattern-js #

[![Join the chat at https://gitter.im/cytisan/pattern-js](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cytisan/pattern-js?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Fluent pattern matching for CoffeeScript and JavaScript.

Implementation of **pattern-js** is inspired by [Functional C#].

## Usage ##
Start with **pattern()** and end  with **matching()**.

## Examples ##

### Constant and Variable Pattern ###

#### CoffeeScript ####

```coffeescript
pattern = require 'pattern-js'
todo = pattern()
    .value("Mon", -> go work)
    .value("Tue", -> go relax)
    .value("Thu", -> go icefishing)
    .when(
        (val) -> val is "Fri" or val is "Sat"
        (day) ->
            if day is bingoDay
                go bingo
                go dancing)
    .value("Sun", -> go church)
    .any(-> go work)
    .matching()

todo "Tue" # go relax
```

#### JavaScript ####

```js
var pattern = require('pattern-js');

var work = 1,
    relax = 2,
    iceFishing = 3,
    bingo = 4,
    dancing = 5;
var bingoDay = "Fri";
var go = function(day) { console.log(day); };

var todo = pattern()
    .value("Mon", function() { go(work); })
    .value("Tue", function() { go(relax); })
    .value("Thu", function() { go(iceFishing); })
    .when(function(val) {  return val === "Fri" || val === "Sat"; },
            function(day) {
                if (day === bingoDay) {
                    go(bingo);
                    go(dancing);
                }})
    .value("Sun", function() { go(church); })
    .any(function() { go(work); })
    .matching();

todo("Fri") // usage
```

### Matching Multiple Elements ###

#### CoffeeScript ####

```coffeescript
detectZeroTuple = pattern()
    .value([0, 0], -> console.log "Both zero")
    .some(
        [0, undefined]
        (var1, var2) -> console.log "First value is 0 in (0, #{ var2 })")
    .some(
        [undefined, 0]
        (var1, var2) -> console.log "Second value is 0 in (#{ var1 }, 0)")
    .any(-> console.log "Both nonzero.")
    .matching()
detectZeroTuple 0, 0
detectZeroTuple 1, 0
detectZeroTuple 0, 10
detectZeroTuple 10, 15
```

#### JavaScript ####

```js
var detectZeroTuple = pattern()
    .value([0, 0], function() { console.log("Both zero"); })
    .some([0, undefined],
            function(var1, var2) { console.log("First value is 0 in (0, " + var2 + ")"); })
    .some([, 0],
            function(var1, var2) { console.log("Second value is 0 in (" + var1 + ", 0)"); })
    .any(function() { console.log("Both nonzero."); })
    .matching();
detectZeroTuple(0, 0);
detectZeroTuple(1, 0);
detectZeroTuple(0, 10);
detectZeroTuple(10, 15);
```


[Functional C#]: http://functionalcsharp.codeplex.com/