function solve(grid)
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

function fill_step(grid, fill)
    ret = false
    for x = 2:size(grid,1)-1
        for y = 2:size(grid,2)-1
            for z = 2:size(grid,3)-1
                nboring = (fill[x-1,y,z] || fill[x,y-1,z] || fill[x,y,z-1])
                nboring = nboring || (fill[x+1,y,z] || fill[x,y+1,z] || fill[x,y,z+1])
                if !grid[x,y,z] && nboring && !fill[x,y,z]
                    fill[x,y,z] = true
                    ret = true
                end
            end
        end
    end
    return ret
end

function floodfill(grid)
    ret = zero(grid)
    ret[1,:,:] .= true
    ret[:,1,:] .= true
    ret[:,:,1] .= true
    ret[size(grid,1),:,:] .= true
    ret[:,size(grid,2),:] .= true
    ret[:,:,size(grid,3)] .= true
    while fill_step(grid, ret)
    end
    return ret
end

grid = zeros(Bool, 25, 25, 25)
for line in readlines(stdin)
    x,y,z = map(x->parse(Int,x.match), eachmatch(r"\d+", line))
    grid[x+2,y+2,z+2] = true
end
outside = floodfill(grid)
@show solve(grid)
@show solve(grid .| .!outside)

