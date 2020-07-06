##
#   Function that evaluates an element of the population generating the tree and the 
#   distance to the target aspect ratio.
#   This functions belongs to a parallelised process to valuate the whole population faster. 
#
#   Parameters
#   ----------- 
#   individual: string cell array 
#               Element to evaluate.
#
#   targetsimilarity: float
#               Indicates the target similarity value considered to filter the population
#
#   targetimage: MxN matrix
#               Representation of the image considered as the target
#
#   printingflag: boolean
#                 Flag that indicates if the drawing process should be done. 1 by default
#
#   pausingtime: int
#                Seconds while the figure will be kept visible if printingFlag is enabled. 0 by default
#
#   resultslocation: string 
#                    Location of the txt files folder including iteration_attempt_generation level
#
#   imglocation: string
#                Location of the population images folder including iteration_attempt_generation level
#
#   Returns
#   --------
#   similarity: Cell array
#               It contains the similarity values of each element
#
#   distancesimilarity: Cell array
#                   It contains the distance value of each element to the target similarity
#
##
function similarity = evaluationParallel(individual, targetimage, resultslocation, imglocation)

    logger.initSLF4O();

    individual = individual{1,1};

    imghashfilename = LsystemGenerator(individual, resultslocation, imglocation)

    #fitness function
    similarity = atei(targetimage, imghashfilename);
    
    logger.info("evaluationParallel: gene: %s | similarity: %f", individual, similarity);

endfunction

