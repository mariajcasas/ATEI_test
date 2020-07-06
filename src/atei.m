##
# Function that receives the url of two images and 
# do the needed operations to compare them appropriately. 
# (Normalisation, converting to bmp, etc)
#
##
function similarity = atei(targetimageurl, imagehashfilename)

  # TODO: The images should be normalised
  # TODO: Thi sextension is not definitive yet but it will be used until
  # saving the image as a bmp is done.
  imageurl = file_in_loadpath([imagehashfilename, ".jpeg"]);

  similarity = imagesmatch(targetimageurl, imageurl);
 

endfunction

function matchingvalue = imagesmatch(image1, image2)
#   image1 and image2 are monochrome bitmaps of the same size
#   1 = white (background) / 0 = black (foreground)
#   returns the percentage of coincident foreground bits

  ## count bits that differ
  noncoincidentbits = sum(sum(image1 != image2));
  ## count bits with value 0 in both images
  coincidentbits    = sum(sum(image1 + image2 == 0));
  ## percetage of bits that match, over all foreground bits
  matchingvalue = coincidentbits / (coincidentbits + noncoincidentbits);

endfunction

