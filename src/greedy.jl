#greedy algorithm

function greedy{T<:Real}(distmat::Matrix{T})
  dmsz = size(distmat)
  numCities = dmsz[1]
  ordDist = sortperm(vec(distmat))[numCities+1:end]
  #node sets, rows Departures, cols Arrivals
  Departures = Int[]
  Arrivals = Int[]
  #bitvector trackers
  bitDep = falses(numCities)
  bitArr = falses(numCities)
  Path = Int[]
  k = 1 #sort indexer
  while length(Departures) < numCities-1
    dk,aj = ind2sub(dmsz,ordDist[k])
    if !bitDep[dk] && !bitArr[aj]
      if !nodeLink(Departures,Arrivals,dk,aj)
        push!(Departures,dk)
        bitDep[dk] = true
        push!(Arrivals,aj)
        bitArr[aj] = true
      end
    end
    k+=1
  end
  #add final edge
  push!(Departures,setdiff(1:numCities,Departures)[1])
  push!(Arrivals,setdiff(1:numCities,Arrivals)[1])

  push!(Path,Departures[1])
  for i in 2:numCities
    idx = inmap(Path[i-1],Departures)
    push!(Path,Arrivals[idx])
  end

  return Path
end

function nodeLink{T}(Departures::Vector{T},Arrivals::Vector{T},dnode::T,anode::T)
  idx = inmap(anode,Departures)
  while idx != 0
    nextCity = Arrivals[idx]
    if nextCity == dnode
      return true
    end
    idx = inmap(nextCity,Departures)
  end
  return false
end


