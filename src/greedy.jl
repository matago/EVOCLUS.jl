#greedy algorithm

function greedy{T<:Real}(distmat::Matrix{T})
  dmsz = size(distmat)
  numCities = dmsz[1]
  ordDist = sortperm(vec(distmat))
  G = Graph(numCities)
  k = 1
  while δ(G) < 2
    dnode,anode = ind2sub(dmsz,ordDist[k])
    if dnode != anode
      d°,a° = degree(G,dnode),degree(G,anode)
      if d° < 2 && a° < 2
        if d° == 0 || a° == 0
          add_edge!(G,dnode,anode)
        elseif !in(dnode,saw(G,anode,ne(G)))
          add_edge!(G,dnode,anode)
        end
      end
    end
  k+=1
  end
  return saw(G,1,numCities)
end


