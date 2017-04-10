## Permutation Population Generators

# Kmedian epsilon with K minpts
function PGen_Kmedian{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_Kmedian(A,k)
  return PGen_clust(A,ϵ,k)
end

# Kmean epsilon with K minpts
function PGen_Kmean{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_Kmean(A,k)
  return PGen_clust(A,ϵ,k)
end

# Grid estimate (uniform) epsilon with K minpts
function PGen_Kgrid{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_grid(A)
  return PGen_clust(A,ϵ,k)
end

# Sample random from K [median,85%] epsilon with K minpts
function PGen_Km85{T <: Real}(A::Matrix{T},k::Int)
  eps = eps_randm85(A,k)
  return PGen_clust(A,eps,k)
end

# Generic cluster generator function
function PGen_clust{T<:Real}(D::DenseMatrix{T}, ϵ::Real, minpts::Int)
  rslt = dbscan(D,ϵ,minpts)
  fillZero!(rslt.assignments)
  cmap = clustmap(rslt.assignments)
  k = length(keys(cmap))
  #solver for the high level clusters of GA
  #the function will eventually return a generator
  function solveTop(pfx::Function)
    tops = zero(Int,k)
    bottoms = zero(Int,k)
    #Extract a random cluster member to represent cluster
    for i in 1:k
      tops[i] = rand(cmap[i])
    end
    cord = pcGA(pfx,tops,false)
    #shortest path for each cluster
    for i in 1:k
      bottoms[i] = pcGA(pfx,cmap[i],true)
    end
    function clustPop(N::Int)
      tgt = zeros(Int,N)
      p = 1
      for i in cord
        l = length(bottoms[i])
        tgt[p:p+l-1] = circshift(bottoms[i],rand(1:l))
        p += l
      end
      return tgt
    end
    return clustPop
  end
  return solveTop
end



