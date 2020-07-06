##
#   Funtion that adds a result line to the given filename
#
#   Parameters
#   -----------
#   filename: String
#             Name of the file where the data will be saved
#
#   resultline: String
#               Formatted string with result data
#
#   Returns
#   -------
#   N/A           
function saveResultInfo(filename, resultline)
    
    fid = fopen(filename,'a');
    fprintf(fid, resultline);
    fclose(fid);

endfunction