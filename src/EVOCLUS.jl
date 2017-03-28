module EVOCLUS

  using StatsBase, Clustering

  export # Mutations
         inversion!, insertion!, swap2!, scramble!, shifting!,
         # Recombinations
         pmx, cx, ox1, ox2, pos,
         # Selections
         ranklinear, tournament, roulette, sus,
         # Algorithms
         sGA,
         # Population Generators
         permGen, clustGen


  ## Recombinations
  include("recombinations.jl")
  ## Mutations
  include("mutations.jl")
  ## Selections
  include("selections.jl")
  ## Utilities
  include("utils.jl")
  ## simple GA
  include("sGA.jl")
  ## Generators
  include("generators.jl")

end # module

