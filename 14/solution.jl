function draw!(cave, xy1, xy2)
    xy1 = [xy1[1], xy1[2] + 1]
    xy2 = [xy2[1], xy2[2] + 1]
    d = clamp.(xy2 .- xy1, -1, 1)
    while xy1 != xy2
        cave[xy1...] = 1
        xy1 += d
    end
    cave[xy2...] = 1
end

function fallingsand!(cave, x, y)
    while y != size(cave, 2)
        if cave[x, y+1] == 0
            y += 1
        elseif cave[x-1, y+1] == 0
            x -= 1
            y += 1
        elseif cave[x+1, y+1] == 0
            x += 1
            y += 1
        else
            cave[x, y] = 2
            return false
        end
    end
    return true
end

cave = zeros(1000, 500)
floor = 0
for line in readlines(stdin)
    global floor
    data = map(x->map(y->parse(Int,y), split(x, ",")), split(line, " -> "))
    for i = 2:length(data)
        floor = max(floor, data[i-1][2] + 2)
        floor = max(floor, data[i][2] + 2)
        @assert data[i-1][1] > 0
        @assert data[i][1] > 0
        draw!(cave, data[i-1], data[i])
    end
end
cave[:,floor+1] .= 1

for i = 0:100000
    @assert !fallingsand!(cave, 500, 1)
    if cave[500, 1] != 0
        @show i+1
        break
    end
end
