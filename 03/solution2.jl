function char(i)
    if i < 27
        return 'a' + i - 1
    else
        return 'A' + i - 27
    end
end

function findtriple(group)
    for i in 1:52
        if all(char(i) in line for line in group)
            return i
        end
    end
end

part2 = 0
for group in Iterators.partition(eachline(stdin), 3)
	global part2 += findtriple(group)
end
@show part2