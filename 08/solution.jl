rows = []
for line in readlines(stdin)
    global rows, task1
    push!(rows, Vector{Char}(line) .- '0')
end
heights = hcat(rows...)
visible = zero(heights)
N = size(heights)[1]

for i = 1:N
    cur = -1
    for j = 1:N
        if heights[i,j] > cur
            visible[i,j] = 1
            cur = heights[i,j]
        end
    end
    cur = -1
    for j = N:-1:1
        if heights[i,j] > cur
            visible[i,j] = 1
            cur = heights[i,j]
        end
    end
end
for j = 1:N
    cur = -1
    for i = 1:N
        if heights[i,j] > cur
            visible[i,j] = 1
            cur = heights[i,j]
        end
    end
    cur = -1
    for i = N:-1:1
        if heights[i,j] > cur
            visible[i,j] = 1
            cur = heights[i,j]
        end
    end
end


@show transpose(heights)
@show transpose(visible)
@show sum(visible)