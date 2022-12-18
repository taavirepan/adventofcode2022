function wrong_solution(grid)
    ret = 0
    for x = 1:size(grid,1)-1
        for y = 1:size(grid,2)-1
            for z = 1:size(grid,3)-1
                if grid[x,y,z] ⊻ grid[x+1,y,z]
                    ret += 1
                end
                if grid[x,y,z] ⊻ grid[x,y+1,z]
                    ret += 1
                end
                if grid[x,y,z] ⊻ grid[x,y,z+1]
                    ret += 1
                end
            end
        end
    end
    return ret
end

function slow_solution(cubes)
    cubes = Set(cubes)
    ret = 0
    for (x,y,z) in cubes
        if !([x-1,y,z] in cubes)
            ret += 1
        end
        if !([x,y-1,z] in cubes)
            ret += 1
        end
        if !([x,y,z-1] in cubes)
            ret += 1
        end
        if !([x+1,y,z] in cubes)
            ret += 1
        end
        if !([x,y+1,z] in cubes)
            ret += 1
        end
        if !([x,y,z+1] in cubes)
            ret += 1
        end
    end
    return ret
end

cubes = []
grid = zeros(Bool, 25, 25, 25)
for line in readlines(stdin)
    x,y,z = map(x->parse(Int,x.match), eachmatch(r"\d+", line))
    grid[x+1,y+1,z+1] = true
    push!(cubes, [x,y,z])
end
@show wrong_solution(grid)
@show slow_solution(cubes)
