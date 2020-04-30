function match = imagesmatch(image1, image2)
#   image1 and image2 are monochrome bitmaps of the same size
#   1 = white (background) / 0 = black (foreground)
#   returns the percentage of coincident foreground bits

  ## count bits that differ
  noncoincidentbits = sum(sum(image1 != image2));
  ## count bits with value 0 in both images
  coincidentbits    = sum(sum(image1 + image2 == 0));
  ## percetage of bits that match, over all foreground bits
  match = 100 * coincidentbits / (coincidentbits + noncoincidentbits);

endfunction

