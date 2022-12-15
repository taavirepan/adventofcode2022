#yyy = 10
yyy = 2000000

function dist(x1, y1, x2, y2)
    return abs(x1-x2) + abs(y1-y2)
end

function closest_is_away(sensors, x, y)
    for (sx, sy, d) in sensors
        if abs(sx-x)+abs(sy-y) <= d
            return false
        end
    end
    return true
end

function process!(sensors, beacons, candidates, beacon)
    sx, sy, bx, by = beacon
    distance = abs(sx - bx) + abs(sy - by)
    push!(sensors, (sx, sy, distance))
    if by == yyy
        push!(beacons, bx)
    end
    for c in candidates
        if dist(c..., sx, sy) <= distance
            setdiff!(candidates, [c])
        end
    end
    for y = max(0,sy-distance-1):min(2*yyy,sy+distance+1)
        x1 = (distance + 1) - abs(y - sy) + sx
        x2 = -(distance + 1) + abs(y - sy) + sx
        if 0 <= x1 && x1 <= 2*yyy && closest_is_away(sensors, x1, y)
            push!(candidates, (x1, y))
        end
        if 0 <= x2 && x2 <= 2*yyy && closest_is_away(sensors, x2, y)
            push!(candidates, (x2, y))
        end
    end
end

sensors = []
beacons = Set()
candidates = Set()
for (i,line) in enumerate(readlines(stdin))
    beacon = map(x->parse(Int,x.match), eachmatch(r"-?\d+", line))
    process!(sensors, beacons, candidates, beacon)
    @show i, length(candidates)
end
sort!(sensors)
@show candidates
