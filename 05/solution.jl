stackdata, moves = split(read(stdin, String), "\n\n")
stackdata = split(stackdata, "\n")
N = 1 + (length(stackdata[1]) - 2) ÷ 4
stacks = [[] for i in 1:N]
for i in 1:length(stackdata)-1
    row = stackdata[end-i]
    for j in 0:N-1
        if row[2 + 4*j] != ' '
            pushfirst!(stacks[1 + j], row[2 + 4*j])
        end
    end
end

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