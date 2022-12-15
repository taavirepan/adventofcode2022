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

function clip(a, b)
    v = clamp.(b - a, -1, 1)
    
    if a[2] < 0
        a += v*-a[2]
    end
    if a[1] < 0
        a += v*-a[1]
    elseif a[1] > 2*yyy
        a += v*(a[1] - 2*yyy)
    end
    
    if b[2] > 2*yyy
        b -= v*(b[2] - 2*yyy)
    end
    if b[1] < 0
        b -= v*-b[1]
    elseif b[1] > 2*yyy
        b -= v*(b[1] - 2*yyy)
    end
    return a,b
end

still_out(a) = a[1] < 0 || a[2] < 0 || a[1] > 2*yyy || a[2] > 2*yyy

function edgeintersect(start, stop, sensor, distance)
    # This could be even faster, if we find the interesections using
    # math, not while loops. But my head hurts already.
    direction = clamp.(stop - start, -1, 1)
    hd = start[1] - sensor[1] + (sensor[2] - start[2]) * direction[1]
    if hd > distance
        return [(start, stop)]
    end
    while dist(start..., sensor...) < distance
        start += direction
    end
    while dist(stop..., sensor...) < distance
        stop -= direction
    end
    cut1 = start
    while cut1 != stop && dist(cut1..., sensor...) >= distance
        cut1 += direction
    end
    cut2 = stop
    while cut2 != start && dist(cut2..., sensor...) >= distance
        cut2 -= direction
    end
    if cut1 == stop
        return [(start, stop)]
    else
        return [(start, cut1), (cut2, stop)]
    end
end

function solved(sensors, a, b)
    v = clamp.(b - a, -1, 1)
    a, b = clip(a, b)
    if a[2] > b[2] || still_out(a) || still_out(b)
        return false
    end
    for (i,(sx,sy,d)) in enumerate(sensors)
        if dist(a..., sx, sy) <= d && dist(b..., sx, sy) <= d
            return false
        end
        segments = edgeintersect(a, b, [sx, sy], d + 1)

        if length(segments) == 1
            a, b = segments[1]
        else
            for (a,b) in segments
                if solved(sensors[i+1:end], a, b)
                    @show a, b, b-a
                    return true
                end
            end
            return false
        end

        if a[2] > b[2] || still_out(a) || still_out(b)
            return false
        end
    end
    @show a, b, b-a
    return true
end

sensors = []
for (i,line) in enumerate(readlines(stdin))
    sx,sy,bx,by = map(x->parse(Int,x.match), eachmatch(r"-?\d+", line))
    d = abs(sx-bx)+abs(sy-by)
    push!(sensors, (sx,sy,d))
end
sort!(sensors,lt=(a,b)->a[2]-a[3]<b[2]+b[3])

for (sx,sy,d) in sensors
    if solved(sensors, [sx, sy-d-1], [sx-d-1, sy])
        break
    end
    if solved(sensors, [sx, sy-d-1], [sx+d+1, sy])
        break
    end
    if solved(sensors, [sx-d-1, sy], [sx, sy+d+1])
        break
    end
    if solved(sensors, [sx+d+1, sy], [sx, sy+d+1])
        break
    end
end