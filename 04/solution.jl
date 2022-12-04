function fullycontained(start1, end1, start2, end2)
    return start1 <= start2 <= end2 <= end1
end

result = 0
for line in eachline(stdin)
    start1,end1,start2,end2 = map(x->parse(Int64, x), match(r"(\d+)-(\d+),(\d+)-(\d+)", line))
	global result += fullycontained(start1, end1, start2, end2) || fullycontained(start2, end2, start1, end1)
end
@show result
