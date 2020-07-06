logger.initSLF4O();

# GENERAL PARAMETERS
iterations = 2; #20000;
numberoftrees = 5; # number of searched trees
maxgenerationsnumber = 10;
populationsize = 15;
selectivepressure = 0.2; # It's not used on this version of fitness function yet

# FITNESS FUNCTION PARAMETERS
targetimage = file_in_loadpath("targetimage.bmp");

# ACI PARAMETERS
maxgenelengthACI = 10; # minimum length recommended = 6
maxnestinglevelACI = 2; # minimum nesting level recommended = 2
paACI = 0.4;   # absolute probability of alteration
probabilitiesvectorACI = [1.0 paACI*rand(1,7)];   # random probabilities for each operator except elitism = 1.0
                                                # 1 = elitism;              2 = alteration;         
                                                # 3 = aleatory duplication  4 = level duplication;    5 = sequence duplication
                                                # 6 = deletion;             7 = insertion             8 = horizontal transfer
# PARALLELISATION PARAMETERS
numCores = nproc(); 


filesrootarray = resultsDirectory("ACIresultsParallelised");
# Saving input data settings
save(filesrootarray{1,7}, "iterations", "numberoftrees", "maxgenerationsnumber", "populationsize", "targetimage", "maxgenelengthACI", "maxnestinglevelACI", "paACI", "probabilitiesvectorACI", "numCores");

iterationtotaltrees = "iteration_1_totaltrees_1"; # This variable is not relevant for this test because there are not generations but it will be kept anyways like maxgenerationsnumber.

[generation, genomehash] = ACI(maxgenelengthACI, maxnestinglevelACI, targetimage, probabilitiesvectorACI, iterationtotaltrees, filesrootarray, maxgenerationsnumber, populationsize, numCores); 

