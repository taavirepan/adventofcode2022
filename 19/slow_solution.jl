function parsebp(data)
    costs = Dict()
    for r in data
        if r[4] == nothing
            c = Dict(names[r[3]]=>parse(Int, r[2]))
            costs[names[r[1]]] = [0, 0, 0, 0]
            for (k,v) in c
                costs[names[r[1]]][k] = v
            end
        else
            c = Dict(names[r[3]]=>parse(Int, r[2]), names[r[5]]=>parse(Int, r[4]))
            costs[names[r[1]]] = [0, 0, 0, 0]
            for (k,v) in c
                costs[names[r[1]]][k] = v
            end
        end
    end
    return costs
end

mutable struct State
	time
	production
	surplus
	upper_bound
end

function build_miner(state, index, miner, stop)
	surplus = copy(state.surplus)
	self = [index == i for i=1:4]
	for t = state.time+1:stop
		if all(surplus .>= miner)
			return State(t, state.production .+ self, surplus .- miner .+ state.production, 9999)
		end
		surplus .+= state.production
	end
end

function upper_bound(state, blueprint, stop)
	production = copy(state.production)
	surplus = copy(state.surplus) .+ production
	for t = state.time+1:stop
		for i in [1, 4, 3, 2]
			miner = blueprint[i]
			if all(surplus .>= miner)
				production[i] += 1
				surplus[i] -= 1
				if i in [3,4]
					surplus[i-1] -= miner[i-1]
				end
				if i == 4
					break
				end
			end
		end
		surplus .+= production
	end
	return surplus[4]
end

function solve(blueprint, stop=32)
	start = State(0, [1, 0, 0, 0], [0, 0, 0, 0], 9999)
	stack = [start]
	best = 0
	while length(stack) > 0
		state = pop!(stack)
		best = max(best, state.production[4] * (stop - state.time) + state.surplus[4])
		if state.upper_bound <= best
			continue
		end
		for i = 1:4
			s = build_miner(state, i, blueprint[i], stop)
			if s != nothing
				s.upper_bound = upper_bound(s, blueprint, stop)
				if s.upper_bound > best
					push!(stack, s)
				end
			end
		end
	end
	return best
end

names = Dict("ore"=>1, "clay"=>2, "obsidian"=>3, "geode"=>4)
task1 = 0
for (i,line) in enumerate(readlines(stdin))
    global cutoff = 0
    data = collect(eachmatch(r"(\w+) robot costs (\d+) (\w+)(?: and (\d+) (\w+))?", line))
    blueprint = parsebp(data)
    @show solve(blueprint)
end

