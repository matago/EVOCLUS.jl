# Genetic Algorithms
# ==================
#         objfun: Objective fitness function
#              N: Search space dimensionality
# initPopulation: Generation function which produce individual population entities.
# populationSize: Size of the population
#  crossoverRate: The fraction of the population at the next generation, not including elite children,
#                 that is created by the crossover function.
#   mutationRate: Probability of chromosome to be mutated
#              ɛ: Positive integer specifies how many individuals in the current generation
#                 are guaranteed to survive to the next generation.
#                 Floating number specifies fraction of population.
#
#
function sGA(objfun::Function,
             N::Int,
             initPopulation::Function = randperm,
             populationSize::Int = 50,
             crossoverRate::Float64 = 0.8,
             mutationRate::Float64 = 0.1,
             ɛ::Real = 0,
             selection::Function = ((x,n)->1:n),
             crossover::Function = ((x,y)->(y,x)),
             mutation::Function = (x->x),
             iterations::Int = 10*N,
             tol::Float64 = 0.0,
             tolIter::Int = 10,
             vstep::Int = iterations,
             rebal::Bool = false,
             inform::Bool = true,
             robust::Bool = false,
             signature::String = "TSP$N")

    store = Dict{Symbol,Any}()

    # Setup parameters
    elite = isa(ɛ, Int) ? ɛ : round(Int, ɛ * populationSize)
    fitFunc = inverseFunc(objfun)

    # Initialize population
    fitness = zeros(Float64,populationSize)
    trueFit = zeros(Float64,populationSize)
    population = Array(Vector{Int}, populationSize)
    offspring = similar(population)

    # Generate population
    for i in 1:populationSize
      population[i] = initPopulation(N)
      fitness[i] = fitFunc(population[i])
    end
    fitidx = sortperm(fitness, rev = true)

    #store descriptive information about run
    keep(inform, :selection, string(selection), store)
    keep(inform, :crossover, string(crossover), store)
    keep(inform, :mutation, string(mutation), store)
    keep(inform, :cxRate, crossoverRate, store)
    keep(inform, :mxRate, mutationRate, store)
    keep(inform, :elite, elite, store)
    keep(inform, :popsize, populationSize, store)
    keep(inform, :id, signature, store)
    keep(inform, :ipop, string(initPopulation), store)

    # Generate and evaluate offspring
    itr = 1
    bestFitness = 0.0
    bestIndividual = 0
    fittol = 0.0
    fittolitr = 1
    while true
        # Select offspring
        selected = selection(fitness, populationSize)

        # Perform mating
        offidx = randperm(populationSize)
        for i in 1:2:populationSize
            j = (i == populationSize) ? i-1 : i+1
            if rand() < crossoverRate
                offspring[i], offspring[j] = crossover(population[selected[offidx[i]]], population[selected[offidx[j]]])
            else
                offspring[i], offspring[j] = copy(population[selected[i]]), copy(population[selected[j]])
            end
        end

        # Perform mutation
        for i in 1:populationSize
            if rand() < mutationRate
                mutation(offspring[i])
            end
        end

        # Elitism
        if elite > 0
          subs = sample(1:populationSize,elite,replace=false)
            for i in 1:elite
                offspring[subs[i]] = population[fitidx[i]]
            end
        end

        # New generation
        for i in 1:populationSize
            population[i] = copy(offspring[i])
            fitness[i] = fitFunc(offspring[i])
            trueFit[i] = objfun(offspring[i])
            rebal && (population[i] = rebalTo1(population[i]))
        end
        fitidx = sortperm(fitness, rev = true)
        ss = summarystats(trueFit)

        # Store generational Data
        keep(robust, :min, ss.min, store)
        keep(robust, :max, ss.max, store)
        keep(robust, :mean, ss.mean, store)
        keep(robust, :median, ss.median, store)

        bestIndividual = fitidx[1]

        curGenFitness = ss.min
        fittol = abs(bestFitness - curGenFitness)
        bestFitness = curGenFitness


        # Verbose step
        (mod(itr,vstep) == 0) && println("BEST:", bestFitness, " : ", "G: ", itr)


        # Terminate:
        #  if fitness tolerance is met for specified number of steps
        if fittol < tol
            if fittolitr > tolIter
                break
            else
                fittolitr += 1
            end
        else
            fittolitr = 1
        end
        # if number of iterations more then specified
        if itr >= iterations
            break
        end
        itr += 1
    end
    keep(inform, :best, bestFitness, store)
    keep(inform, :pop, population, store)

    # return population[bestIndividual], bestFitness, itr, fittol, store
    return store
end