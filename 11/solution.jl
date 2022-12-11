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
for data in Iterators.partition(input, 7)
    push!(monkeys, parse(Monkey, data))
end

task1 = zeros(Int, length(monkeys))
for round = 1:20
    for (i, monkey) in enumerate(monkeys)
        while length(monkey.items) > 0
            task1[i] += 1
            item = monkey.operation(popfirst!(monkey.items)) ÷ 3
            if item % monkey.test == 0
                push!(monkeys[monkey.iftrue + 1].items, item)
            else
                push!(monkeys[monkey.iffalse + 1].items, item)
            end
        end
    end
end
sort!(task1)
@show task1[end] * task1[end - 1]