module EVOCLUS

  export # Mutations
         inversion!, insertion!, swap2!, scramble!, shifting!,
         # Recombinations
         pmx, cx, ox1, ox2, pos


  ## Recombinations
  include("recombinations.jl")
  ## Mutations
  include("mutations.jl")

end # module

