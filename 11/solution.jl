struct Monkey
    items
    operation
    test
    iftrue
    iffalse
end

function lambdify(s)
    expr = Meta.parse(replace(s, "new =" => "old ->"))
    eval(expr)
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

throw_to(monkey, item) = 1 + (item % monkey.test == 0 ? monkey.iftrue : monkey.iffalse)

function solve(monkeys; divide = 1, rounds = 10000)
    lcm = prod(monkey.test for monkey in monkeys)
    result = zeros(Int, length(monkeys))
    items = [copy(monkey.items) for monkey in monkeys]
    
    for round = 1:rounds
        for (i, monkey) in enumerate(monkeys)
            while length(items[i]) > 0
                result[i] += 1
                item = (monkey.operation(popfirst!(items[i])) ÷ divide) % lcm
                push!(items[throw_to(monkey, item)], item)
            end
        end
    end
    sort!(result)
    @show result[end] * result[end - 1]
end

monkeys = []
for data in Iterators.partition(readlines(stdin), 7)
    push!(monkeys, parse(Monkey, data))
end
solve(monkeys, divide=3, rounds=20)
solve(monkeys)