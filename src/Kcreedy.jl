
function Kcreedy{T<:Real}(distmat::Matrix{T},n::Int)
  dmsz = size(distmat)
  numCities = dmsz[1]
  scan = kmeans(distmat,n)
  asgn = scan.assignments
  master = collect(1:numCities)
  ordDist = sortperm(vec(distmat))
  G = Graph(numCities)
  for i in 1:n
    members = master[asgn .== i]
    m_edges = subgreedy(distmat[members,members])
    for (j,k) in m_edges
      add_edge!(G,members[j],members[k])
    end
  end
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
  return saw(G,1,numCities)
end