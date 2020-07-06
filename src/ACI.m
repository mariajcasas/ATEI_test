##
#   Function that makes to evolution an initial population based on some input constraints.
#   If an element that fits the target aspect ratio is found, it finishes. Otherwise, makes to evolution the
#   next poulation doing some modifications on their genomes applying indirect codification.
#   Generation of the population and evaluation processes are parallelised.
#
#   Parameters
#   ----------- 
#   maxgenelength: int
#                  Maximum length of the generated gene. 
#
#   maxnestinglevel: int
#                    Maximum number of nesting levels permitted in the generated gene.
#
#   targetimage: MxN matrix           
#
#   probabilitiesvector: float vector
#                        Operators probabilities
#
#   iterationtotaltrees: string
#                     Value of the iteration and the tree of the simulation progress   
#
#   filesrootarray: Cell string array with the following structure:
#              1: txt results files folder
#              2: svg files folder
#              3: loggin errors txt file
#              4: changessequence: txt file of changes sequence history. The pattern of the file is the following:
#                            <generation> <ancestor> <changessequence> where <changesequence> will contain all the operators applied
#                            to the genome. Examples:
#                                   - 1 operator: 1 186 N[GGG-GGG]3
#                                   - more than one operator: 1 16 C+8N[+GGG++G]3
#                            If an operator didn't change the genome it will appear like this: 1 95 S=I+8
#                            The pattern of the elitism operator is <generation> <ancestor> =
#                           Example: 1 207 =
#              5: phylogenetictree: txt file of the phylogenetic history
#              6: indexhashtable: txt file of hash names list of each generation
#              7: inputsettings: txt file of input data settings 
#              8: executiontimeresults: txt file of the execution time results 
# 
#   maxgenerationsnumber: int
#                         Maximum number of generations to look for the individual
#                         with given aspect ratio
#
#   populationsize: int
#                   Number of elements that componds the trees population
#
#   numCores: int
#             Number of cpus available (number of cores or twice as much with hyperthreading)  
#                                     
#   Returns
#   --------
#   relativetime: Generation when the element was found
#
#   genomehashbestelements: Cell array
#                           It contains the hash values of the best elements
#
##
function [relativetime, genomehashbestelements] = ACI(maxgenelength, maxnestinglevel, targetimage, probabilitiesvector, iterationtotaltrees, filesrootarray, maxgenerationsnumber, populationsize, numCores)

    logger.initSLF4O();

    # population generation
    logger.info("ACI - Generating population: size %d | maxgenelength %d | maxnestingnum %d | maxgenerationsnumber %d", populationsize, maxgenelength, maxnestinglevel, maxgenerationsnumber);
    generatingpopulationtime = tic();

    # Population generating parallelisation process
    fun = @(idx) geneGeneratorParallel(idx, maxgenelength, maxnestinglevel);
    P = pararrayfun(numCores, fun, 1:populationsize, "UniformOutput", false);

    generatingpopulationelapsedtime = toc(generatingpopulationtime);
    logger.info("ACI: Generating population: Elapsed time %d", generatingpopulationelapsedtime);
    # executiontimeresults.txt
    saveResultInfo(filesrootarray{1,8}, sprintf("generationPopulation: %d\n", generatingpopulationelapsedtime));
    
    relativetime = 0;
    genomehash = "";

    # changessequence.txt
    saveResultInfo(filesrootarray{1,4}, sprintf("ACI - Iteration_Totaltrees: %s\n", iterationtotaltrees));
    #indexHashTable.txt
    saveResultInfo(filesrootarray{1,6}, sprintf("ACI - Iteration_Totaltrees: %s\n", iterationtotaltrees));

    for generation=1:maxgenerationsnumber
        
        # Logging
        logger.info("ACI - Iteration_Totaltrees: %s Generation: %d", iterationtotaltrees, generation);

        iterationtotaltreesgeneration = strcat(filesep, iterationtotaltrees, filesep, "generation_", num2str(generation));
        imglocation = strcat(filesrootarray{1,2}, iterationtotaltreesgeneration);
        mkdir(imglocation);
        resultslocation = strcat(filesrootarray{1,1}, iterationtotaltreesgeneration);
        mkdir(resultslocation);

        # Evaluation of the current population
        acitimeStart = tic();
        
        # Parallelisation
        fun = @(row_idx) evaluationParallel(row_idx, targetimage, resultslocation, imglocation);
        [similaritypopulation, genomehashvector] = pararrayfun(numCores, fun, P, "UniformOutput", false);
        # UniformOutput option returns the outputs contained in cell arrays
        similaritypopulation = cell2mat(similaritypopulation);

        fitnesstime = toc(acitimeStart);
        logger.info("ACI: Evaluation of the current population - Elapsed time %d", fitnesstime);

        # population index - hash table
        save_header_format_string("");
        saveResultInfo(filesrootarray{1,6}, sprintf("Generation: %d\n", generation));
        #saveResultInfo(filesrootarray{1,6}, sprintf("%s\n", genomehashvector{:})); Hold on by now
        
        similarelements = find(similaritypopulation != 0); #filtering the elements with similarity == 0
        [bestsimilarity, bestindex] = max(similaritypopulation(similarelements)); #identifying the best element
        bestcandidates = similarelements(:,bestindex);

        for element = 1:length(bestcandidates)
            relativetime = generation;
            genomehashbestelements(element) = genomehashvector(:, bestcandidates);

            saveResultInfo(filesrootarray{1,4}, sprintf('%d %d=\n', generation, bestindex));
            logger.info("ACI: Best element found - generation: %d | genomehash: %s", generation, char(genomehashbestelements(element)));
            saveResultInfo(filesrootarray{1,8}, sprintf('generation: %d | genomehash: %s\n', generation, char(genomehashbestelements(element))));
            break;
        endfor

        # next generation
        acievolutiontimeStart = tic();

        P = evolution(P, similaritypopulation, probabilitiesvector, generation, filesrootarray);

        evolutionelapsedtime = toc(acievolutiontimeStart);
        logger.info("ACI: Evolution of the current population - Elapsed time %d", evolutionelapsedtime); 

        # executiontimeresults.txt
        saveResultInfo(filesrootarray{1,8}, sprintf("%d : %d | %d\n", generation, fitnesstime, evolutionelapsedtime));        
    endfor

endfunction

##
#   Function that uses the current population to create the children 
#   that make up the next generation. 
#   The algorithm selects a group of individuals in the current population, 
#   called parents, who contribute their genes—the entries of their vectors—to their children. 
#   The algorithm usually selects individuals that have better fitness values as parents.
#
#   The genetic algorithm creates different types of children for the next generation:
#
#    TODO: Operators
#
#   Parameters
#   ----------- 
#   populationset: cell array
#               Set of elements that componses the population 
#
#   similaritypopulation: float vector
#                         Similarity vector of the population
#                     
#   probabilitiesvector: float vector
#                        Probabilities vector of each operator
#                        1 = elitism;              2 = alteration;         
#                        3 = aleatory duplication  4 = level duplication;    5 = sequence duplication
#                        6 = deletion;             7 = insertion
#
#   generation: int
#               Current value of generation in the experiment execution
#
#   filesrootarray: Cell string array with the following structure:
#              1: resultsfileroot: txt files folder location
#              2: imgfileroot: svg files folder location
#              3: logfileroot: txt file of loggin errors
#              4: changessequencefileroot: name and root of the txt file of changes sequence history
#              5: phylogenetictreefileroot: name and root of the txt file of the phylogenetic history
#              6: indexhashtablefileroot: name and root of the txt file of hash names list of each generation
#   
#   Returns
#   --------
#   newpopulationset: New population set of individuals after having applied some modifications on their genomes.
##
function newpopulationset = evolution(populationset, similaritypopulation, probabilitiesvector, generation, filesrootarray)

    elitismprobability = rand(1) <= probabilitiesvector(1); # Elitism strategy to select the best element
    if (elitismprobability)
        similarelements = find(similaritypopulation != 0); #filtering the elements with similarity == 0
        if length(similarelements) != 0
            [bestaspectratio, bestindex] = min(similaritypopulation(similarelements)); #looking for the best element
            bestcandidate = similarelements(bestindex);
            populationset{bestindex};
            G{1} = populationset{bestindex};
            
            saveResultInfo(filesrootarray{1,4}, sprintf('%d %d =\n', generation, bestindex));
        else
            # As all of them are equals, one of them is chosen 
            indexchosen = randi(length(populationset));
            G{1} = populationset{indexchosen};
            saveResultInfo(filesrootarray{1,4}, sprintf('%d %d =\n', generation, indexchosen));
        endif
        
    endif

    absoluteprobabilitiesvector = probabilitiesvector;

    for j=elitismprobability + 1:length(populationset)
        
        changesset = "";
        # selects the genome to be modified
        i = selection(populationset, similaritypopulation);
        G{j} = populationset{i};

        operatorsvector = rand(size(probabilitiesvector)) <= probabilitiesvector; # (Binary vector) Decides what operators should be applied
    
        # Save the generation and the ancestor 
        saveResultInfo(filesrootarray{1,4}, sprintf('%d %d ', generation + 1, i));

        if (operatorsvector(2) && rand(1) <= probabilitiesvector(2))          # alteration ALTERATION - A
            [G{j}, segment, positioningenome] = implicitCodification("alteration", G{j}, "");
            changesset = concatOperators(changesset, "A", segment, positioningenome);
        endif

        if (operatorsvector(3) && rand(1) <= probabilitiesvector(3))          # aleatory duplication RANDOM - R
            [G{j}, segment, positioningenome] = implicitCodification("aleatorydup", G{j}, "");
            changesset = concatOperators(changesset, "R", segment, positioningenome);
        endif

        if (operatorsvector(4) && rand(1) <= probabilitiesvector(4))          # level duplication LEVELED - L
            [G{j}, segment, positioningenome] = implicitCodification("leveldup", G{j}, "");
            changesset = concatOperators(changesset, "L", segment, positioningenome);
        endif

        if (operatorsvector(5) && rand(1) <= probabilitiesvector(5))          # sequence duplication CONTIGUOS - C
            [G{j}, segment, positioningenome] = implicitCodification("sequencedup", G{j}, "");
            changesset = concatOperators(changesset, "C", segment, positioningenome);
        endif

        if (operatorsvector(6) && rand(1) <= probabilitiesvector(6))          # deletion DELETION - D
            [G{j}, segment, positioningenome] = implicitCodification("deletion", G{j}, "");
            changesset = concatOperators(changesset, "D", segment, positioningenome);
        endif

        if (operatorsvector(7) && rand(1) <= probabilitiesvector(7))          # insertion INSERTION - I
            [G{j}, segment, positioningenome] = implicitCodification("insertion", G{j}, "");
            changesset = concatOperators(changesset, "I", segment, positioningenome);
        endif

        if (operatorsvector(8) && rand(1) <= probabilitiesvector(8))          # horizontal transfer TRANSFER - T
            i = selection(populationset, similaritypopulation); # Selects an aleatory individual of the population
            [G{j}, segment, positioningenome] = implicitCodification("horizontaltransfer", G{j}, populationset{i});
            changesset = concatOperators(changesset, "T", segment, positioningenome);
        endif
        
        # save the changes sequence applied to the genome
        changesetline = "";
        if ~isempty(changesset)
            changesetline = sprintf('%s\n', changesset);
        else
            changesetline = sprintf('=\n');
        endif
        saveResultInfo(filesrootarray{1,4}, changesetline);

    endfor

    newpopulationset = G;

endfunction

##
#
#
#
#
##
function changesset = concatOperators(changesset, operator, segment, position)

    if (!isempty(segment) && position != 0)
        changesset = [changesset, operator, segment, num2str(position)];
    else
        changesset = [changesset, segment];
    endif

endfunction