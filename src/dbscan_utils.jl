# derive epsilon given K=minpts using the median
function eps_Kmedian{T <: Real}(A::Matrix{T},k::Int)
  return median(Knearest(A,k))
end

# derive epsilon given K=minpts using the mean
function eps_Kmean{T <: Real}(A::Matrix{T},k::Int)
  return mean(Knearest(A,k))
end

#derive epsilon from unit grid of region
function eps_grid{T <: Real}(A::Matrix{T})
  gd = maximum(A)/sqrt(2)
  n = size(A,1)
  return gd/sqrt(n)
end

#derive epsilon from random [median, .85%]
function eps_randm85{T <: Real}(A::Matrix{T},k::Int)
  i = rand(0.5:0.01:0.85)
  return quantile(Knearest(A,k),i)
end

#derivce epsilon from quanitle at K level
function eps_Q{T <: Real}(A::Matrix{T},Q::Float64,k::Int)
  @assert 0.0 <= Q <= 1.0 "Quantile Q must be in range [0.0, 1.0]."
  return quantile(Knearest(A,k),Q)
end

#= Strip all zero values and return a vector
    of all remaining entities =#
function nonZeros{T <: Real}(A::Matrix{T})
  nnzA = countnz(A)
  NZs = Vector{T}(nnzA)
  count = 1
  if nnzA > 0
    for j=indices(A,2), i=indices(A,1)
      Aij = A[i,j]
      if Aij != zero(T)
        NZs[count] = Aij
        count += 1
      end
    end
  end
  return NZs
end

function Knearest{T <: Real}(A::Matrix{T},k::Int)
  n = size(A,2)
  mins = zeros(T,n)
  for i=1:n
    a = A[:,i]
    mins[i] = a[sortperm(a)[k+1]]
  end
  return mins
end


