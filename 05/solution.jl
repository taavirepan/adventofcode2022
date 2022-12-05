stackdata, moves = split(read(stdin, String), "\n\n")
N = stackdata[end-1] - '0' # I have no shame
stackdata = reshape(Vector{Char}(stackdata * "\n"), (4 * N, :))
stacks = [filter(x->x != ' ', stackdata[2 + 4*i,:])[1:end-1] for i in 0:N-1]

for move in split(moves, "\n")
    if move == ""
        continue
    end
    m = match(r"move (\d+) from (\d+) to (\d+)", move)
    count = parse(Int32, m[1])
    from = parse(Int32, m[2])
    to = parse(Int32, m[3])
    # prepend!(stacks[to], reverse(splice!(stacks[from], 1:count)))
    prepend!(stacks[to], splice!(stacks[from], 1:count))
end

for stack in stacks
    print(stack[1])
end
println()