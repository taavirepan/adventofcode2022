using DataStructures: DefaultDict

fs = DefaultDict(0)
cur = ["/"]

for line in readlines(stdin)
    global cur, fs
    if line == "\$ cd /"
        cur = ["/"]
    elseif line == "\$ cd .."
       pop!(cur) 
    elseif startswith(line, "\$ cd")
        name = match(r"\$ cd (.+)", line)[1]
        push!(cur, name * "/")
    elseif line == "\$ ls"

    elseif !startswith(line, "dir")
        m = match(r"(\d+) (.+)", line)
        p = ""
        for d in cur
            p = p * d
            fs[p] += parse(Int64, m[1])
        end
    end
end

task1 = 0
for (k,v) in fs
    if v <= 100000
        global task1 += v
    end
end
@show task1

target = 30000000 - (70000000 - fs["/"])
task2 = [v for (k,v) in fs if v >= target]
sort!(task2)
@show task2
