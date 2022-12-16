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

function linelineintersect(start1, direction1, start2, direction2)
    if direction1 == direction2
        a = start1 - direction1 * start1[1]
        b = start2 - direction2 * start2[1]
        return a == b
    end
    @assert direction1[2] == 1 && direction2[2] == 1
    offset2 = start2 - start1
    v = (offset2[1] - offset2[2]*direction1[1]) ÷ (direction1[1] - direction2[1])
    u = offset2[2] + v
    return start1 + u*direction1
end

function cuts(start, stop, sensor, distance)
    direction = clamp.(stop - start, -1, 1)
    other_direction = [-direction[1], direction[2]]
    pts = Any[
        linelineintersect(start, direction, sensor - [0, distance], other_direction),
        linelineintersect(start, direction, sensor - [0, distance], direction),
        linelineintersect(start, direction, sensor + [0, distance], other_direction),
        linelineintersect(start, direction, sensor + [0, distance], direction),
    ]
    pts = filter(p->isa(p,Vector), pts)
    pts = filter(p->start[2] < p[2] && p[2] < stop[2], pts)
    if length(pts) == 1
        return pts[1], nothing
    end
    if length(pts) < 2
        return nothing, nothing
    end
    sort!(pts, lt=(a,b)->a[2]<b[2])
    nothing, (pts[1] + direction, pts[2] - direction)
end

function edgeintersect(start, stop, sensor, distance)
    direction = clamp.(stop - start, -1, 1)
    p, c = cuts(start, stop, sensor, distance)
    if !isnothing(p)
        if dist(start..., sensor...) < distance
            start = p
        elseif dist(stop..., sensor...) < distance
            stop = p
        end
    elseif !isnothing(c)
        if dist(c[1]..., sensor...) <= distance
            cut1, cut2 = c
            return [(start, cut1), (cut2, stop)]
        end
    else
        if dist(start..., sensor...) < distance
            start = stop
        elseif dist(stop..., sensor...) < distance
            stop = start
        end
    end
    return [(start, stop)]
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
    @assert a == b
    @show a
    @show a[1]*4000000 + a[2]
    @assert a[1]*4000000 + a[2] == 13360899249595
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