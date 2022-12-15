#y = 10
y = 2000000

sensors = []
beacons = Set()
for line in readlines(stdin)
    sx, sy, bx, by = map(x->parse(Int,x.match), eachmatch(r"\d+", line))
    distance = abs(sx - bx) + abs(sy - by)
    push!(sensors, (sx, sy, distance))
    if by == y
        push!(beacons, bx)
    end
end
sort!(sensors)

task1 = 0
sensor = 1
for x = sensors[1][1]-sensors[1][3]:sensors[end][1]+sensors[end][3]
    global sensor, task1
    if x in beacons
        continue
    end
    for sensor = 1:length(sensors)
        sx, sy, distance = sensors[sensor]
        if abs(x - sx) + abs(y - sy) <= distance
            task1 += 1
            break
        end
    end
end
@show task1

#2486888 wroong