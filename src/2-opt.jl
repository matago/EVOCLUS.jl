#implementation of 2-opt

function two_opt{T<:Real}(distmat::Matrix{T}, path::Vector{Int})
  return _two_opt(distmat,path,false)
end

function two_opt!{T<:Real}(distmat::Matrix{T}, path::Vector{Int})
  return _two_opt(distmat,path,true)
end

function _two_opt{T<:Real}(distmat::Matrix{T}, path::Vector{Int}, inplace::Bool)
	# size checks
	n = length(path)
	if size(distmat, 1) != size(distmat, 2)
		error("Distance matrix passed to two_opt must be square.")
	end

	# in place or no?
  path = inplace ? path : copy(path)

	# main loop
	# check every possible switch until no 2-swaps reduce objective
	# if the path passed in is a loop (first/last nodes are the same)
	# then we must keep these the endpoints of the path the same
	# ie just keep it a loop, and therefore it doesn't matter which node is at the end
	# if the path is not a cycle, we can do any reversing we like
	isCycle = path[1] == path[end]
	switchLow = isCycle ? 2 : 1
	switchHigh = isCycle ? n - 1 : n
	prevCost = Inf
	curCost = pathcost(distmat, path)
	while prevCost > pathcost(distmat, path)
		prevCost = curCost
		# we can't change the first
		for i in switchLow:(switchHigh-1)
			for j in (i+1):switchHigh
				altCost = pathcost_rev(distmat, path, i, j)
				if altCost < curCost
					curCost = altCost
					reverse!(path, i, j)
				end
			end
		end
	end
	return path
end



function pathcost{T<:Real}(distmat::Matrix{T}, path::Vector{Int}, lb::Int = 1, ub::Int = length(path))
	cost = zero(T)
	for i in lb:(ub - 1)
		@inbounds cost += distmat[path[i], path[i+1]]
	end
	return cost
end

function pathcost_rev{T<:Real}(distmat::Matrix{T}, path::Vector{Int}, revLow::Int, revHigh::Int)
	cost = zero(T)
	# if there's an initial unreversed section
	if revLow > 1
		for i in 1:(revLow - 2)
			@inbounds cost += distmat[path[i], path[i+1]]
		end
		# from end of unreversed section to beginning of reversed section
		@inbounds cost += distmat[path[revLow - 1], path[revHigh]]
	end
	# main reverse section
	for i in revHigh:-1:(revLow + 1)
		@inbounds cost += distmat[path[i], path[i-1]]
	end
	# if there's an unreversed section after the reversed bit
	n = length(path)
	if revHigh < length(path)
		# from end of reversed section back to regular
		@inbounds cost += distmat[path[revLow], path[revHigh + 1]]
		for i in (revHigh + 1):(n-1)
			@inbounds cost += distmat[path[i], path[i+1]]
		end
	end
	return cost
end