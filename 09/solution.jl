function step(head, tail)
    d = head - tail
    l = sum(abs.(d))
    if any(x == 0 for x in d) && l > 1
        return clamp.(d, -1, 1)
    elseif l <= 2
        return false
    end
    return clamp.(d, -1, 1)
end

directions = Dict('R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1])
rope = fill([0,0], 10)
places = Dict(1 => Set([[0, 0]]), 9 => Set([[0, 0]]))
for line in readlines(stdin)
    global rope
    direction = directions[line[1]]
    n = parse(Int64, line[3:end])
    for i in 1:n
        rope[1] += direction
        for j in 1:9
            while step(rope[j], rope[j+1]) != false
                rope[j+1] += step(rope[j], rope[j+1])
                if j in keys(places)
                    push!(places[j], rope[j+1])
                end
            end
        end
    end

end
@show length(places[1])
@show length(places[9])
