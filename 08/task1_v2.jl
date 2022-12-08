rows = []
for line in readlines(stdin)
    global rows, task1
    push!(rows, Vector{Char}(line) .- '0')
end
heights = hcat(rows...)

# max that slowly increases, so that only trees strictly larger then previous trees are visible.
# with regular max() below we would also count the trees that are equal in height previous highest tree
maxincr(a,b) = a==b ? a + 1e-6 : max(a,b)

direction1 = accumulate(maxincr, heights, dims=1, init=-1)
direction2 = reverse(accumulate(maxincr, reverse(heights, dims=1), dims=1, init=-1), dims=1)
direction3 = accumulate(maxincr, heights, dims=2, init=-1)
direction4 = reverse(accumulate(maxincr, reverse(heights, dims=2), dims=2, init=-1), dims=2)

threshold = min.(direction1, direction2, direction3, direction4)

@show sum(heights .>= threshold)