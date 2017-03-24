#Permuation Recombinations

function pmx{T <: Integer}(v1::Vector{T}, v2::Vector{T})
    s = length(v1)
    from, to = rand(1:s, 2)
    from, to = from > to ? (to, from)  : (from, to)
    c1 = similar(v1)
    c2 = similar(v2)

    # Swap
    c1[from:to] = v2[from:to]
    c2[from:to] = v1[from:to]

    # Fill in from parents
    for i in vcat(1:from-1, to+1:s)
        # Check conflicting offspring
        in1 = inmap(v1[i], c1, from, to)
        if in1 == 0
            c1[i] = v1[i]
        else
            tmpin = in1
            while tmpin > 0
                tmpin = inmap(c2[in1], c1, from, to)
                in1 = tmpin > 0 ? tmpin : in1
            end
            c1[i] = v1[in1]
        end

        in2 = inmap(v2[i], c2, from, to)
        if in2 == 0
            c2[i] = v2[i]
        else
            tmpin = in2
            while tmpin > 0
                tmpin = inmap(c1[in2], c2, from, to)
                in2 = tmpin > 0 ? tmpin : in2
            end
            c2[i] = v2[in2]
        end
    end
    return c1, c2
end

# Order crossover
function ox1{T <: Integer}(v1::Vector{T}, v2::Vector{T})
  s = length(v1)
  from, to = rand(1:s, 2)
  from, to = from > to ? (to, from)  : (from, to)
  c1 = zeros(v1)
  c2 = zeros(v2)
  # Swap
  c1[from:to] = v2[from:to]
  c2[from:to] = v1[from:to]
  # Fill in from parents
  k = to+1 > s ? 1 : to+1 #child1 index
  j = to+1 > s ? 1 : to+1 #child2 index
  for i in vcat(to+1:s,1:from-1)
    while in(v1[k],c1)
      k = k+1 > s? 1 : k+1
    end
    c1[i] = v1[k]
    while in(v2[j],c2)
      j = j+1 > s? 1 : j+1
    end
    c2[i] = v2[j]
  end
  return c1, c2
end

# Cycle crossover
function cx{T <: Integer}(v1::Vector{T}, v2::Vector{T})
  s = length(v1)
  c1 = zeros(v1)
  c2 = zeros(v2)

  f1 = true #switch
  k = 1
  while k > 0
    idx = k
    if f1
      #cycle from v1
      while c1[idx] == zero(T)
        c1[idx] = v1[idx]
        c2[idx] = v2[idx]
        idx = inmap(v2[idx],v1)
      end
    else
      #cycle from v2
      while c2[idx] == zero(T)
        c1[idx] = v2[idx]
        c2[idx] = v1[idx]
        idx = inmap(v1[idx],v2)
      end
    end
    f1 $= true
    k = inmap(zero(T),c2)
  end
  return c1,c2
end

# Order-based crossover
function ox2{T <: Integer}(v1::Vector{T}, v2::Vector{T})
  s = length(v1)
  c1 = copy(v1)
  c2 = copy(v2)

  for i in 1:s
    if rand(Bool)
      idx1 = inmap(v2[i],v1)
      idx2 = inmap(v1[i],v2)
      c1[idx1] = zero(T)
      c2[idx2] = zero(T)
    end
  end

  for i in 1:s
    if !in(v2[i],c1)
      tmpin = inmap(zero(T),c1)
      c1[tmpin] = v2[i]
    end
    if !in(v1[i],c2)
      tmpin = inmap(zero(T),c2)
      c2[tmpin] = v1[i]
    end
  end
  return c1,c2
end

# Position-based crossover
function pos{T <: Integer}(v1::Vector{T}, v2::Vector{T})
  s = length(v1)
  c1 = zeros(v1)
  c2 = zeros(v2)

  for i in 1:s
    if rand(Bool)
      c1[i] = v2[i]
      c2[i] = v1[i]
    end
  end

  for i in 1:s
    if !in(v1[i],c1)
      tmpin = inmap(zero(T),c1)
      c1[tmpin] = v1[i]
    end
    if !in(v2[i],c2)
      tmpin = inmap(zero(T),c2)
      c2[tmpin] = v2[i]
    end
  end
  return c1,c2
end
