stream = readline(stdin)

for i = 4:length(stream)
    if length(Set(stream[i-3:i])) == 4
        @show i
        break
    end
end