module EVOCLUS

  using StatsBase, Clustering

  export # Mutations
         inversion!, insertion!, swap2!, scramble!, shifting!,
         # Recombinations
         pmx, cx, ox1, ox2, pos,
         # Selections
         ranklinear, tournament, roulette, sus,
         # Algorithms
         sGA, rclGA,
         # Population Generators
         Gen_perm, clustGen,
         ## Auto Population Generators
         Gen_Kmedian, Gen_Kmean, Gen_Kgrid, Gen_Km85,
         # DBSCAN epsilon derivation methods
         eps_Kmedian, eps_Kmean, eps_grid, eps_randm85



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
  ## Reclustering GA
  include("rclGA.jl")
  ## Generators
  include("generators.jl")
  ## DBSCAN Utilities
  include("dbscan_utils.jl")

end # module

