function process(elves, ordering)
    ret = Set()
    targets = Dict()
    elftargets = Dict()
    directions = [
        [0,-1],
        [0,1],
        [-1,0],
        [1,0],
    ]
    circshift!(directions, ordering)
    for elf in elves
        if !any(elf.+d in elves for d in [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]])
            continue
        end
        t = nothing
        for dir in directions
            tangent = [x==0 ? 1 : 0 for x in dir]
            if !any(elf .+ dir .+ tangent*i in elves for i in [-1, 0, 1])
                t = elf .+ dir
                break
            end
        end
        if t != nothing
            get!(targets,t,0)
            targets[t] += 1
            elftargets[elf] = t
        end
    end
    for elf in elves
        t = get(elftargets, elf, nothing)
        if t != nothing && targets[t] == 1
            @assert !(t in ret)
            push!(ret, t)
        else
            push!(ret, elf)
        end
    end
    @assert length(ret) == length(elves)
    return ret
end

function result(elves)
    x1, y1 = 10000,10000
    x2, y2 = -10000, -10000
    for elf in elves
        x1, x2 = min(x1, elf[1]), max(x2, elf[1])
        y1, y2 = min(y1, elf[2]), max(y2, elf[2])
    end
    return (x2 - x1 + 1) * (y2 - y1 + 1) - length(elves)
end

function draw(elves)
    x1, y1 = 10000,10000
    x2, y2 = -10000, -10000
    for elf in elves
        x1, x2 = min(x1, elf[1]), max(x2, elf[1])
        y1, y2 = min(y1, elf[2]), max(y2, elf[2])
    end
    # map = 
end


data = []
for line in readlines(stdin)
    global data
    push!(data, Vector{Char}(line))
end
data = hcat(data...)
elves = Set([[i[1], i[2]] for i in findall(data .== '#')])
draw(elves)
# @show result(elves)
# @show elves
for i = 1:100000
    if i%1000 == 0
        @show i
    end
    
    enew = process(elves, (i-1)%4)
    if enew == elves
        @show i
        break
    end
    global elves = enew
end
# @show elves
# @show result(elves)