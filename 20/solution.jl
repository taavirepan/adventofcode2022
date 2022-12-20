data = []
for (i,line) in enumerate(readlines(stdin))
    push!(data,parse(Int, line))
end
done = zeros(Bool, length(data))
for _=1:length(data)
    i = 1
    while done[i]
        i = (i) % length(data) +1
    end
    popat!(done, i)
    x = popat!(data, i)
    j = (i + length(data)*2 + x - 1) % length(data) + 1
    insert!(data, j, x)
    insert!(done, j, true)
end
circshift!(data, findfirst(data.==0)-1)

task1=0
for i = [1000,2000,3000]
    i = (i) % length(data) + 1
    global task1 += data[i]
end
@show task1
