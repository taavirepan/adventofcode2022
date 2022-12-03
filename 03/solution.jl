function findcommon(line)
	n = length(line) ÷ 2
	a, b = line[1:n], line[n+1:end]
	for x in a
		if x in b
			return x
		end
	end
	@assert false
end

function priority(c)
	p = 1 + c - 'A'
	if p < 27 
		return p + 26
	else
		return 1 + c - 'a'
	end
end

result = 0
for line in eachline(stdin)
	global result += priority(findcommon(line))
end
@show result