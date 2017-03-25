using StatsBase

# Rank-based fitness assignment
# sp - selective linear presure in [1.0, 2.0]
function ranklinear(sp::Float64)
  @assert 1.0 <= sp <= 2.0 "Selective pressure has to be in range [1.0, 2.0]."
  function rank(fitness::Vector{Float64}, N::Int)
      λ = float(length(fitness))
      idx = sortperm(fitness)
      ranks = zeros(Integer(λ))
      for i in 1:Integer(λ)
          ranks[i] = ( 2.0- sp + 2.0*(sp - 1.0)*(idx[i] - 1.0) / (λ - 1.0) ) /λ
      end
      return sample(1:Integer(λ),weights(ranks),N,replace = false)
  end
  return rank
end

# Tournament selection
function tournament(groupSize::Integer)
  groupSize <= 0 && error("Group size needs to be positive")
  function tournamentN(fitness::Vector{Float64},N::Integer)
    selection = Array(Int, N)
    nF = length(fitness)

    for i in 1:N
      contenders = sample(1:nF,groupSize,replace = false)
      winner = first(contenders)
      wf = fitness[winner]
      for k in 2:groupSize
        contender = contenders[k]
        if fitness[contender] > wf
          winner = contender
          wf = fitness[contender]
        end
      end
      selection[i] = winner
    end
    return selection
  end
  return tournamentN
end

# Roulette wheel (proportionate selection) selection
function roulette(fitness::Vector{Float64}, N::Integer)
  n = length(fitness)
  wv = weights(fitness)
  sample(1:n,wv,N,replace = true)
end

# Stochastic universal sampling (SUS)
function sus(fitness::Vector{Float64}, N::Integer)
  n = length(fitness)
  @assert N <= n "Number of selections (N) must be less than numeber of elements"
  wv = weights(fitness)
  sample(1:n,wv,N,replace = false)
end


