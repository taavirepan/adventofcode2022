function cycle()
    global register, current_cycle, task1, task2
    current_x = current_cycle % 40
    current_y = (current_cycle ÷ 40) % 6
    if register - 1 <= current_x <= register + 1
        task2[1 + current_y][1 + current_x] = '#'
    else
        task2[1 + current_y][1 + current_x] = '.'
    end
    current_cycle += 1
    if current_cycle in [20, 60, 100, 140, 180, 220]
        task1 += current_cycle * register
    end
end

register = 1
current_cycle = 0
task1 = 0
task2 = [fill('.', 40) for i = 1:6]
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
println(join([join(line, "") for line in task2], "\n"))
