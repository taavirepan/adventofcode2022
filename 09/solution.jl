function step(head, tail)
    d = head - tail
    if d[1] == 0 && abs(d[2]) > 1
        return clamp.(d, -1, 1)
    end
    if d[2] == 0 && abs(d[1]) > 1
        return clamp.(d, -1, 1)
    end
    if sum(abs.(d)) <= 2
        return false
    end
    return clamp.(d, -1, 1)
end

directions = Dict('R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1])
head = [0, 0]
tail = [0, 0]
places = Set()
push!(places, tail)
for line in readlines(stdin)
    global head, tail
    direction = directions[line[1]]
    n = parse(Int64, line[3:end])
    for i in 1:n
        head += direction
        while step(head, tail) != false
            tail += step(head, tail)
            push!(places, tail)
        end
    end

end
@show length(places)
# 6987 wrong
# 6168 wrong