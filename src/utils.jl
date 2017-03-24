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