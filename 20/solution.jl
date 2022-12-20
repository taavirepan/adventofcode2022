key = (811589153)
# key = 1
data = []
for (i,line) in enumerate(readlines(stdin))
    push!(data,parse(Int, line) * key)
end

ordering = collect(1:length(data))
for loops = 1:10
    for i=1:length(data)
        i = findfirst(ordering .== i)
        x = popat!(data, i)
        j = (i + length(data)*key*3 + x - 1) % length(data) + 1
        insert!(data, j, x)
        insert!(ordering, j, popat!(ordering, i))
    end
end
circshift!(data, findfirst(data.==0)-1)

task1=0
for i = [1000,2000,3000]
    i = (i) % length(data) + 1
    global task1 += data[i]
end
@show task1
