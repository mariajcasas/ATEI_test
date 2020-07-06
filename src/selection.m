##
#   The selection function chooses parents for the next generation based on their scaled values from the fitness scaling function. 
#   The scaled fitness values are called the expectation values. An individual can be selected more than once as a parent, 
#   in which case it contributes its genes to more than one child.
#   
#   It uses the roulette wheel algorithm. 
#   Parameters
#   ----------- 
#   populationset: cell array
#               Set of elements that componses the population 
#                     
#   similaritypopulation: float vector
#                         Similarity vector of the population
#
#   Returns
#   --------
#   selectedindex: Index of the element selected with a proportional probability to its similarity to the target aspect ratio
##
function selectedindex = selection(populationset, similaritypopulation)

    searchedsimilarity = rand(size(similaritypopulation))./similaritypopulation;                    
    [value, selectedindex] = max(searchedsimilarity);

endfunction