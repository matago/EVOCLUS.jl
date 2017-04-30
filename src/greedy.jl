#greedy algorithm

function greedy{T<:Real}(distmat::Matrix{T})
  dmsz = size(distmat)
  numCities = dmsz[1]
  ordDist = sortperm(vec(distmat))
  G = Graph(numCities)
  k = 1
  #main loop
  while ne(G) < numCities-1
    dnode,anode = ind2sub(dmsz,ordDist[k])
    if dnode != anode
      d°,a° = degree(G,dnode),degree(G,anode)
      if d° < 2 && a° < 2
        if d° == 0 && a° == 0
          add_edge!(G,dnode,anode)
        elseif independent(G,dnode,anode)
          add_edge!(G,dnode,anode)
        end
      end
    end
    k+=1
  end
  #final edge addition
  add_edge!(G,findin(degree(G),1)...)
  return G
  # return saw(G,1,numCities)
end

function independent(G::Graph,dnode::Int,anode::Int)
  valid = true
  for vset in connected_components(G)
    if valid && in(dnode,vset) && in(anode,vset)
      valid = false
    end
  end
  return valid
end

