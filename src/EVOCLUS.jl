module EVOCLUS

  using StatsBase

  export # Mutations
         inversion!, insertion!, swap2!, scramble!, shifting!,
         # Recombinations
         pmx, cx, ox1, ox2, pos,
         # Selections
         ranklinear, tournament, roulette, sus


  ## Recombinations
  include("recombinations.jl")
  ## Mutations
  include("mutations.jl")
  ## Selections
  include("selections.jl")

end # module

