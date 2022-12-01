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

result = 0;
read_data("input") do x
	global result = max(result, sum(x));
end
println(result);
