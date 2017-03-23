#Permuation Mutations

function inversion!{T <: Vector}(recombinant::T)
    l = length(recombinant)
    from, to = rand(1:l, 2)
    from, to = from > to ? (to, from)  : (from, to)
    l = div(to - from,2)+1
    for i in 0:(l-1)
        swap!(recombinant, from+i, to-i)
    end
    return recombinant
end

function insertion!{T <: Vector}(recombinant::T)
    l = length(recombinant)
    from, to = rand(1:l, 2)
    val = recombinant[from]
    deleteat!(recombinant, from)
    return insert!(recombinant, to, val)
end

function swap2!{T <: Vector}(recombinant::T)
    l = length(recombinant)
    from, to = rand(1:l, 2)
    swap!(recombinant, from, to)
    return recombinant
end


function scramble!{T <: Vector}(recombinant::T)
    l = length(recombinant)
    from, to = rand(1:l, 2)
    from, to = from > to ? (to, from)  : (from, to)
    recombinant[from:to] = shuffle!(recombinant[from:to])
    return recombinant
end


function shifting!{T <: Vector}(recombinant::T)
    l = length(recombinant)
    from, to, where = sort(rand(1:l, 3))
    patch = recombinant[from:to]
    diff = where - to
    if diff > 0
        # move values after tail of patch to the patch head position
        for i in 1:diff
            recombinant[from+i-1] = recombinant[to+i]
        end
        # place patch values in order
        start = from + diff
        for i in 1:length(patch)
            recombinant[start+i-1] = patch[i]
        end
    end
    return recombinant
end


# Utils
# =====
function swap!{T <: Vector}(v::T, from::Int, to::Int)
    val = v[from]
    v[from] = v[to]
    v[to] = val
end




