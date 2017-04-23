## Permutation Population Generators

#random
function Gen_perm(N::Int)
  function rperm(N::Int)
    return randperm(N)
  end
end

# Kmedian epsilon with K minpts
function Gen_Kmedian{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_Kmedian(A,k)
  return Gen_clust(A,ϵ,k)
end

# Kmean epsilon with K minpts
function Gen_Kmean{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_Kmean(A,k)
  return Gen_clust(A,ϵ,k)
end

# Grid estimate (uniform) epsilon with K minpts
function Gen_Kgrid{T <: Real}(A::Matrix{T},k::Int)
  ϵ = eps_grid(A)
  return Gen_clust(A,ϵ,k)
end

# Sample random from K [median,85%] epsilon with K minpts
function Gen_Km85{T <: Real}(A::Matrix{T},k::Int)
  eps = eps_randm85(A,k)
  return Gen_clust(A,eps,k)
end

# Generic cluster generator function
function Gen_clust{T<:Real}(D::DenseMatrix{T}, ϵ::Real, minpts::Int)
  rslt = dbscan(D,ϵ,minpts)
  fillZero!(rslt.assignments)
  cmap = clustmap(rslt.assignments)
  k = length(keys(cmap))
  function clustPop(N::Int)
    tgt = zeros(Int,N)
    p = 1
    for i in randperm(k)
      l = length(cmap[i])
      tgt[p:p+l-1] = cmap[i]
      p += l
    end
    return tgt
  end
  return clustPop
end

#nearest neighbor generator
function Gen_NN{T<:Real}(D::DenseMatrix{T})
  function nnPop(N::Int)
    nearest_neighbor(D,rand(1:N))
  end
  return nnPop
end


