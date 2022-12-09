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
rope = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
places = Set()
push!(places, [0,0])
for line in readlines(stdin)
    global rope
    direction = directions[line[1]]
    n = parse(Int64, line[3:end])
    for i in 1:n
        rope[1] += direction
        for j in 1:9
            while step(rope[j], rope[j+1]) != false
                rope[j+1] += step(rope[j], rope[j+1])
                if j == 9
                    push!(places, rope[10])
                end
            end
        end
    end

end
@show length(places)
# 6987 wrong
# 6168 wrong