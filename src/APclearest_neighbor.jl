#clustered nearest neaighbor
function APclearest_neighbor{T<:Real}(distmat::Matrix{T}, firstcity::Int = 0)

  scan = affinityprop(-((eye(distmat).*maximum(distmat)).+distmat))
  asgn = scan.assignments
  bitClust = trues(length(scan.counts))
	numCities = size(distmat, 1)
  bitNode = trues(numCities)
  master = collect(1:numCities)
	# put first city on path
	path = Vector{Int}()
  sizehint!(path,numCities)
	if firstcity == 0
		firstcity = rand(1:numCities)
	end
	push!(path, firstcity)
	# cities to visit
  while in(true,bitNode)
    curCity = path[end]
    bitNode[curCity] = false
    Cid = asgn[curCity]
    if Cid == 0
      citiesToVisit = master[bitNode]
    elseif bitClust[Cid]
      bitPals = asgn.==Cid
      citiesToVisit = master[bitNode&bitPals]
      bitClust[Cid] = false
    else
      citiesToVisit = master[bitNode]
    end
	# nearest neighbor loop
  	while asgn[curCity] == Cid && !isempty(citiesToVisit)
      dists = distmat[citiesToVisit,curCity]
  		_, nextInd = findmin(dists)
  		nextCity = citiesToVisit[nextInd]
  		push!(path, nextCity)
      bitNode[nextCity] = false
  		deleteat!(citiesToVisit, nextInd)
      curCity = path[end]
  	end
  end

	return path
end

