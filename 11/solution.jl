struct Monkey
    items
    operation
    test
    iftrue
    iffalse
end

function lambdify(s)
    expr = Meta.parse(replace(s, "new =" => "old ->"))
    Base.eval(expr)
end

function Base.parse(::Type{Monkey}, s)
    Monkey(
        collect(parse(Int, x.match) for x in eachmatch(r"\d+", s[2])),
        lambdify(split(s[3], ": ")[2]),
        parse(Int, match(r"\d+", s[4]).match),
        s[5][end] - '0',
        s[6][end] - '0',
    )
end

input = readlines(stdin)
monkeys = []
gcd = 1
for data in Iterators.partition(input, 7)
    push!(monkeys, parse(Monkey, data))
    global gcd *= monkeys[end].test
end

task2 = zeros(Int, length(monkeys))
for round = 1:10000
    for (i, monkey) in enumerate(monkeys)
        while length(monkey.items) > 0
            task2[i] += 1
            item = monkey.operation(popfirst!(monkey.items)) % gcd
            if item % monkey.test == 0
                push!(monkeys[monkey.iftrue + 1].items, item)
            else
                push!(monkeys[monkey.iffalse + 1].items, item)
            end
        end
    end
end
sort!(task2)
@show task2[end] * task2[end - 1]
