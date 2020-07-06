##
# Function that calculates the hash value of datetime moment plus the hostname
# value of the system where Octave is running, using the hash function MD5
#
#   Parameters
#   -----------
#   genome: string that represents the individual. this value is needed to avoid 
#           collisions
#
#   Returns
#   --------
#   datetimehash: hash value using the MD5 hash function of datetime now plus
#   the hostname system value where Octave is running, to distinguish values 
#   that can be generated at the same time on different threads, (if paralellism is ON)
#
##
function datetimehash = getHash(genome)

    datetimehash = hash("md5", strcat(datestr(now, 'ddmmyyyyHHMMSSFFF'), gethostname(), genome, rand(1)));

endfunction
