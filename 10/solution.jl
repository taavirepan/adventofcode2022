function cycle()
    global register, current_cycle, task1
    current_cycle += 1
    if current_cycle in [20, 60, 100, 140, 180, 220]
        task1 += current_cycle * register
    end
end

register = 1
current_cycle = 0
task1 = 0
for line in readlines(stdin)
    if line == "noop"
        cycle()
    elseif (m = match(r"addx (.+)", line)) != nothing
        cycle()
        cycle()
        global register += parse(Int, m[1])
    end
end
@show task1
