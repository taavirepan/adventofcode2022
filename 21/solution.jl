function run(data, v1, op, v2)
    v1 = run(data, data[v1]...)
    v2 = run(data, data[v2]...)
    if op == "+"
        return v1 + v2
    end
    if op == "*"
        return v1 * v2
    end
    if op == "/"
        return div(v1, v2)
    end
    if op == "-"
        return v1 - v2
    end
    if op == "=="
        return v1 - v2
    end
end
run(data, value) = value

function eval(data, v)
    data["humn"] = v
    return run(data, data["root"]...)
end

function find(data, a, b)
    a1 = eval(data, a)
    a2 = eval(data, a+1)
    b1 = eval(data, b)
    b2 = eval(data, b+1)
    if a1 > 0 && b1 <= 0
        if a + 1 >= b
            return b
        end
        @show (a,b) => (a1, b1)
        m = div(a+b, 2)
        mv = eval(data, m)
        @show m, mv
        if mv > 0
            return find(data, m, b)
        else
            return find(data, a, m)
        end
    end
    if a1>a2 && b1>b2
        return find(data, b, b*10)
    end
    @show a1,a2
    @show b1, b2
end

data = Dict()
for line in readlines(stdin)
    m1 = match(r"(\w+): (\d+)", line)
    m2 = match(r"(\w+): (\w+) (.) (\w+)", line)

    if m1 != nothing
        data[m1[1]] = [parse(BigInt, m1[2])]
    end
    if m2 != nothing && m2[1] == "root"
        data[m2[1]] = [m2[2], "==", m2[4]]
    elseif m2 != nothing
        data[m2[1]] = [m2[2], m2[3], m2[4]]
    end
end
@show run(data, data["root"]...)
# @show data["root"]
# @show data["humn"]
@show find(data, BigInt(1), BigInt(100))

# wrong 3032671800355