## Permutation Population Generators

#random
function permGen(N::Int)
  randperm(N)
end

function clustGen{T<:Real}(D::DenseMatrix{T}, eps::Real, minpts::Int)
  rslt = dbscan(D,eps,minpts)
  fillZero!(rslt.assignments)
  cmap = clustmap(rslt.assignments)
  k = length(keys(cmap))
  function clustPop(N::Int)
    tgt = zeros(Int,N)
    p = 1
    for i in randperm(k)
      l-1 = length(cmap[i])
      tgt[p:p-1+l] = cmap[i]
      p += l
    end
    return tgt
  end
  return clustPop
end


#Utilities
function clustmap{T}(a::AbstractArray{T})
    d = Dict{T,Vector{Int}}()
    for i = 1 : length(a)
        @inbounds k = a[i]
        if !haskey(d, k)
            d[k] = findin(a,k)
        end
    end
    return d
end

function fillZero!{T <: Integer}(v::Vector{T})
  k = 1
  for i in 1:length(v)
    if v[i] == zero(T)
      v[i] = k
      k += 1
    end
  end
  return v
end


