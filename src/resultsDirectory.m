##
# Function that creates the output results directory given the name of the folder
#   to be created as root. It will nest the "images" subdirectory to the given one
#   to save the images files, if proceed.
#
#           <workspace>/results/<foldername>    : for data files
#                                   |
#                                   -> logging_yyyymmddTHHMMSS.txt : for logging errors   
#                                   |
#                                   -> images/  : for image files
#
#   Parameters
#   -----------
#   foldername: Name of the directory where the output results will be saved
#
#   Returns
#   --------
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
##
function filesrootarray = resultsDirectory(foldername)

    location = fileparts(mfilename('fullpath'));

    fileroot = datestr(now);
    fileroot = strrep(fileroot, "-", "_");
    fileroot = strrep(fileroot, " ", "_");
    fileroot = strrep(fileroot, ":", "_");
    fileroot = [foldername, filesep, fileroot];
    resultsfileroot = [location, filesep, "results", filesep, fileroot];
    mkdir(resultsfileroot);
    
    # next directory will be used to save images files
    imgfileroot = [resultsfileroot, filesep, "images"];
    mkdir(imgfileroot);

    logfileroot = [resultsfileroot, filesep, "Logs"];
    mkdir(logfileroot);
    
    logfileroot = [logfileroot, filesep, "loggging.log"];
    
    changessequencefileroot = [resultsfileroot, filesep, "changessequence.txt"];

    phylogenetictreefileroot = [resultsfileroot, filesep, "phylogenetictree.txt"];

    indexhashtablefileroot = [resultsfileroot, filesep, "IndexHashTable.txt"];

    inputsettingsfileroot = [resultsfileroot, filesep, "InputSettings.txt"];

    timeresultsfileroot = [resultsfileroot, filesep, "executiontimeresults.txt"];
    
    filesrootarray = {resultsfileroot, imgfileroot, logfileroot, changessequencefileroot, phylogenetictreefileroot, indexhashtablefileroot, inputsettingsfileroot, timeresultsfileroot};
    
endfunction