pattern = require '../pattern'
expect = require('chai').expect

matchObj = () ->
    describe('when(predicates, exp)', () ->
        it 'should match object with defined properties', matchObjTest)
matchObjTest = () ->
    map = pattern()
        .when(
            (val) -> val is 'foo'
            () -> 'bar')
        .any(() -> 'bummer')
        .matching()
    expect(map('foo')).to.equal('bar')
    expect(map('boo')).to.not.equal('bar')

constantPattern = () ->
    describe(
        'when, value'
        () -> it(
            'should match constants exactly'
            constantPatternTests))
constantPatternTests = () ->
    constantPatternTest1()
    constantPatternTest2()
    constantPatternTest3()
constantPatternTest1 = () ->
    three = 3
    oneTwoThree = () -> "Found 1, 2, or 3!"
    filter123 = pattern()
        .value(1, oneTwoThree)
        .value([2], oneTwoThree)
        .value(three, oneTwoThree)
        .any((var1) -> var1)
        .matching()
    for x in [1..10]
        filter123(x)
constantPatternTest2 = () ->
    color =
        red: 0
        green: 1
        blue: 2
    printColorName = pattern()
        .value(color.red, () -> "Red")
        .value(color.green, () -> "Green")
        .value(color.blue, () -> "Blue")
        .matching()
    expect(printColorName(color.red)).to.equal("Red")
    expect(printColorName(color.green)).to.equal("Green")
    expect(printColorName(color.blue)).to.equal("Blue")
constantPatternTest3 = () ->
    moe     = {name : 'moe', luckyNumbers : [13, 27, 34]}
    clone   = {name : 'moe', luckyNumbers : [13, 27, 34]}
    mutator = {name : 'moe', luckyNumbers : [13, 27, 34, 0]}
    match = pattern().value(clone, -> true).matching()
    expect(match(moe)).to.be.ok
    expect(match(mutator)).to.not.be.ok

matchDirect = () ->
    describe(
        'direct(directExp)'
        () -> it(
            'should match with same numbers of arguments'
            matchDirectTest))
matchDirectTest = () ->
    direct = pattern()
        .direct((var1, var2, var3) -> var1+var2+var3)
        .matching()
    expect(direct(1,2,3)).to.equal(6)

matchSome = () ->
    describe(
        'some([patterns], exp)'
        -> it(
            'should match with defined patterns'
            matchSomeTest))
matchSomeTest = () ->
    some = pattern()
        .some(
            [
                undefined
                undefined
                3
                (val) -> val % 4 == 0
            ]
            (exp) -> true)
        .any(() -> false)
        .matching()
    expect(some(4,4,3,8)).to.be.ok
    expect(some(1,2,3)).to.equal(false)
    expect(some(1,2,3,9)).to.equal(false)

matchFuncs = () ->
    matchObj()
    constantPattern()
    matchDirect()
    matchSome()

describe('match', matchFuncs)

