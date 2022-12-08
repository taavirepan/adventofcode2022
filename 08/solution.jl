rows = []
for line in readlines(stdin)
    global rows, task1
    push!(rows, Vector{Char}(line) .- '0')
end
heights = hcat(rows...)
visible = zero(heights)
scenic = zero(heights) .+ 1
N = size(heights)[1]

directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

function walk(i, j, dir)
    di, dj = dir
    for d = 1:N
        if (1 <= i + di*d <= N) && (1 <= j + dj*d <= N)
            if heights[i+di*d,j+dj*d] >= heights[i,j]
                return d, false
            end
        else
            return d - 1, true
        end
    end
end

for i = 1:N
    for j = 1:N
        for direction in directions
            dist, border = walk(i, j, direction)
            if border
                visible[i,j] = 1
            end
            scenic[i,j] *= dist
        end
    end
end

@show transpose(heights)
@show transpose(visible)
@show sum(visible)
@show maximum(scenic)