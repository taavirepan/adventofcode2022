function fullycontained(start1, end1, start2, end2)
    return start1 <= start2 <= end2 <= end1
end

function overlaps(start1, end1, start2, end2)
    return (start1 <= start2 <= end1) || (start1 <= end2 <= end1)
end

part1 = 0
part2 = 0
for line in eachline(stdin)
    start1,end1,start2,end2 = map(x->parse(Int64, x), match(r"(\d+)-(\d+),(\d+)-(\d+)", line))
	global part1 += fullycontained(start1, end1, start2, end2) || fullycontained(start2, end2, start1, end1)
    global part2 += overlaps(start1, end1, start2, end2) || overlaps(start2, end2, start1, end1)
end
@show part1
@show part2
