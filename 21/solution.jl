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
end
run(data, value) = value

function eval(data, v)
    data["humn"] = v
    return run(data, data["root"]...)
end

function find(data, a, b) # doesn't work with sample input at the moment
    a1 = eval(data, a)
    a2 = eval(data, a+1)
    b1 = eval(data, b)
    b2 = eval(data, b+1)
    if a1 > 0 && b1 <= 0
        if a + 1 >= b
            return b
        end
        m = div(a+b, 2)
        mv = eval(data, m)
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
    if m2 != nothing
        data[m2[1]] = [m2[2], m2[3], m2[4]]
    end
end
@show run(data, data["root"]...)
data["root"] = [data["root"][1], "-", data["root"][3]]
@show find(data, BigInt(1), BigInt(100))
