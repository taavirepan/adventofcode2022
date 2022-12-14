function draw!(cave, xy1, xy2)
    d = clamp.(xy2 .- xy1, -1, 1)
    cave[xy1...] = 1
    while xy1 != xy2
        cave[(xy1+=d)...] = 1
    end
end

function fallingsand!(cave, x, _)
    for y = 1:size(cave, 2)-1
        nx = filter(z->cave[z,y+1]==0, [x, x-1, x+1])
        if length(nx) == 0
            cave[x,y] = 2
            return false
        end
        x = first(nx)
    end
    return true
end

cave = zeros(1000, 500)
floor = 0
for line in readlines(stdin)
    global floor
    data = map(x->map(y->parse(Int,y), split(x, ",")), split(line, " -> "))
    for (from, to) = zip(data[1:end], data[2:end])
        floor = max(floor, from[2], to[2])
        draw!(cave, from + [0, 1], to + [0, 1])
    end
end

task1 = copy(cave)
for i = 0:1000
    if fallingsand!(task1, 500, 1)
        println("task1 = ", i)
        break
    end
end

cave[:,floor + 3] .= 1
for i = 0:100000
    fallingsand!(cave, 500, 1)
    if cave[500, 1] != 0
        println("task2 = ", i + 1)
        break
    end
end
