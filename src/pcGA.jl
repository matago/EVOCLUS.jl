
function pGA(objfun::Function,
             vals::Vector{Int},
             actual::Bool
             )
    # Harbored Parameters
    N = length(vals)
    iterations = 10*N
    initPopulation = randperm
    populationSize = 50
    crossoverRate = 0.5
    mutationRate = 0.5
    selection = tournament(2)
    crossover = ox1
    mutation = swap2!
    ɛ = 0.1

    # Setup parameters
    elite = isa(ɛ, Int) ? ɛ : round(Int, ɛ * populationSize)
    fitFunc = inverseFunc(objfun)
    # Initialize population
    fitness = zeros(Float64,populationSize)
    population = Array(Vector{Int}, populationSize)
    offspring = similar(population)
    # Generate population
    for i in 1:populationSize
      population[i] = initPopulation(N)
      fitness[i] = fitFunc(vals[population[i]])
    end
    fitidx = sortperm(fitness, rev = true)
    # Generate and evaluate offspring
    itr = 1
    bestFitness = 0.0
    bestIndividual = 0
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
            fitness[i] = fitFunc(vals[offspring[i]])
        end
        fitidx = sortperm(fitness, rev = true)
        bestIndividual = fitidx[1]
        curGenFitness = objfun(vals[population[fitidx[1]]])
        fittol = abs(bestFitness - curGenFitness)
        bestFitness = curGenFitness
        # if number of iterations more then specified
        if itr >= iterations
            break
        end
        itr += 1
    end
    if actual
      out = vals[population[fitidx[1]]]
    else
      out = population[fitidx[1]]
    return out
end