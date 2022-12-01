function read_data(handler::Function, filename)
	x = Int[]
	open(filename) do io
		for s in eachline(io)
			if s == ""
				handler(x)
				x = Int[]
			else
				push!(x, parse(Int, s))
			end
		end
	end
	handler(x)
end

result = Int[]
read_data("input") do x
	push!(result, sum(x))
end
sort!(result);
println(result[end-1])
println(sum(result[end-2:end]))
