## Utilities

function vswap!{T <: Vector}(v1::T, v2::T, idx::Integer)
    val = v1[idx]
    v1[idx] = v2[idx]
    v2[idx] = val
end

function inmap{T}(v::T, c::Vector{T}, from::Integer = 1, to::Integer = length(c))
    exists = 0
    for j in from:to
        if exists == 0 && v == c[j]
            exists = j
        end
    end
    return exists
end

function swap!{T <: Vector}(v::T, from::Int, to::Int)
    val = v[from]
    v[from] = v[to]
    v[to] = val
end

# Inverts an objective funtion
function inverseFunc(f::Function)
  function fitnessFunc{T <: Vector}(x::T)
    return 1.0/(f(x)+eps())
  end
  return fitnessFunc
end

# Collecting interim values
function keep(interim, v, vv, col)
    if interim
        if !haskey(col, v)
            col[v] = typeof(vv)[]
        end
        push!(col[v], vv)
    end
end

# ReBalance a Permuation to start at 1
function rebalTo1{T <: Integer}(v::Vector{T})
  n = length(v)
  k = inmap(one(T),v)
  v = v[vcat(k:n,1:k-1)]
  return v
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

#Graph Utilities
#check if two nodes are connected
function independent(G::Graph,dnode::Int,anode::Int)
  valid = true
  for vset in connected_components(G)
    if valid && in(dnode,vset) && in(anode,vset)
      valid = false
    end
  end
  return valid
end