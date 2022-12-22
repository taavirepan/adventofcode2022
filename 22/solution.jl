struct Position
    x
    y
    d
end

function rotate(d, r)
    if r == "R"
        d = d % 4 + 1
    elseif r == "L"
        d = (2 + d) % 4 + 1
    else
        @assert r == nothing || r == "x"
    end
    return d
end

movedirections = [[1, 0], [0, 1], [-1, 0], [0, -1]]
function move(position, r)
    nx, ny = [position.x, position.y] .+ movedirections[position.d]
    d = rotate(position.d, r)

    if ny > length(map)
        ny = 1
    elseif ny < 1
        ny = length(map)
    end

    if map[ny][nx] == ' ' && position.d == 1
        nx = findfirst(x != ' ' for x in map[ny])
    elseif map[ny][nx] == ' ' && position.d == 3
        nx = findlast(x != ' ' for x in map[ny])
    elseif map[ny][nx] == ' ' && position.d == 2
        ny = findfirst(map[i][nx] != ' ' for i in 1:length(map))
    elseif map[ny][nx] == ' ' && position.d == 4
        ny = findlast(map[i][nx] != ' ' for i in 1:length(map))
    end

    if map[ny][nx] == '.'
        return Position(nx, ny, d)
    else
        @assert map[ny][nx] == '#'
    end
    return Position(position.x, position.y, d)
end

map = []
for line in readlines(stdin)
    if length(line) == 0
        continue
    elseif isdigit(line[1])
        global directions = line
    else
        push!(map, " "*line*"                                                                                                          ")
    end
end
x0 = findfirst(x == '.' for x in map[1])
@show pos = Position(x0, 1, 1)
for m in eachmatch(r"(\d+)([LRx])", directions * "x")
    n = parse(Int, m[1])
    for i = 1:n
        global pos = move(pos, i == n ? m[2] : nothing)
    end
end
@show pos.y * 1000 + (pos.x - 1) * 4 + (pos.d - 1)
