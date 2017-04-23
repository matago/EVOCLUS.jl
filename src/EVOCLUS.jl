module EVOCLUS

  using StatsBase, Clustering

  export # Mutations
         inversion!, insertion!, swap2!, scramble!, shifting!,
         # Recombinations
         pmx, cx, ox1, ox2, pos,
         # Selections
         ranklinear, tournament, roulette, sus,
         # Algorithms
         sGA, pcGA,
         # Population Generators
         Gen_perm, clustGen,
         ## Auto Population Generators
         Gen_Kmedian, Gen_Kmean, Gen_Kgrid, Gen_Km85,
         ## Partial Solve Pop Generators
         PGen_Kmedian, PGen_Kmean, PGen_Kgrid, PGen_Km85,
         # DBSCAN epsilon derivation methods
         eps_Kmedian, eps_Kmean, eps_grid, eps_randm85,
         # Nearest Neighbor
         nearest_neighbor,
         # 2-opt
         two_opt, two_opt!




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
  ## partial GA
  include("pcGA.jl")
  ## Generators
  include("generators.jl")
  ## Partial Solve Generators
  include("Pgenerators.jl")
  ## DBSCAN Utilities
  include("dbscan_utils.jl")
  ## Nearest neighbor
  include("nearest_neighbor.jl")
  ## Two_opt
  include("2-opt.jl")

end # module

