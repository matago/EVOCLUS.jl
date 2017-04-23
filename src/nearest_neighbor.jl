#nearest neighbors tour implementation

function nearest_neighbor{T<:Real}(distmat::Matrix{T}, firstcity::Int = 0)
  maxval = maximum(distmat)
	numCities = size(distmat, 1)
	# put first city on path
	path = Vector{Int}()
	if firstcity == 0
		firstcity = rand(1:numCities)
	end
	push!(path, firstcity)
	# cities to visit
	citiesToVisit = setdiff(1:numCities,path)
	# nearest neighbor loop
	while !isempty(citiesToVisit)
		curCity = path[end]
    dists = distmat[citiesToVisit,curCity]
		_, nextInd = findmin(dists)
		nextCity = citiesToVisit[nextInd]
		push!(path, nextCity)
		deleteat!(citiesToVisit, nextInd)
	end

	return path
end

