# match = 
#   value: (obj)
#   success: (boolean)

_ = require 'underscore'
isArray= _.isArray
isEqual = _.isEqual

class PatternMatching
    constructor: (@_f) ->

PatternMatching::when = (predicates, exp) ->
    new PatternMatching (inner) =>
        match = @_f(inner)
        if match.success
            match
        else
            fail = () ->
                value: match.value
                success: false
            ps = if isArray(predicates) then predicates else [predicates]
            if ps.length is match.value.length
                for i in [0...ps.length]
                    if ps[i].apply(this, [match.value[i]]) isnt true
                        return fail()
                value: exp.apply(this, match.value)
                success: true
            else
                fail()

PatternMatching::any = (valExp) ->
    new PatternMatching (inner) =>
        match = @_f(inner)
        if match.success
            match
        else
            value: valExp()
            success: true

PatternMatching::matching = PatternMatching::end = ->
    (inner...) =>
        ret = @_f(inner)
        if ret.success
            ret.value
        else
            undefined

PatternMatching::value = (expected, valExp) ->
    predicates = []
    if isArray(expected)
        for e in expected
            predicates.push (val) -> isEqual val, e
    else
        predicates.push (val) -> isEqual val, expected
    @.when(predicates, (val) -> valExp(val))

PatternMatching::direct = (directExp) ->
    new PatternMatching (inner) =>
        match = @_f(inner)
        if match.success
            match
        else
            if match.value.length is directExp.length
                value: directExp.apply(this, match.value)
                success: true
            else
                value: match.value
                success: false

PatternMatching::some = (patterns, exp) ->
    getPredicate = (pattern) ->
        if typeof(pattern) is 'undefined'
            (val) -> true
        else if typeof(pattern) is 'function'
            pattern
        else if isArray(pattern)
            (val) ->
                p = () ->
                    for v in val
                        if !getPredicate(v)
                            return false
                    return true
                isArray(val) \
                and val.length is pattern.length \
                and p()
        else if (typeof(pattern) is 'object') \
        and (typeof(pattern._wrapped___func) is 'function')
            (val) -> isEqual val, pattern._wrapped___func
        else
            (val) -> isEqual val, pattern
    predicates = (getPredicate p for p in patterns)
    @.when(predicates, exp)

pattern = () ->
    new PatternMatching (inner) ->
        value: inner
        success: false

pattern.constfunc = (func) ->
    _wrapped___func: func

root = this
if typeof(exports) isnt 'undefined' then exports.pattern = pattern
if typeof(module) isnt 'undefined' then module.exports = pattern
root.pattern = pattern

