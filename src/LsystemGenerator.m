##
# 
#   Function that simulates the string-rewriting-system in 2D.
#
#   The construction rule is especified in the file, as well as the initial string (gene)   
#   and the number of iterations. In this case this value is set to 3.
#   The result string represents the genome of the individual.
#
#   The results are plotted with a chosen angle between the axioms and a chosen length of each axiom.
#   The character, which represents the beginning of a branch "[",
#   save the current position and angle, while "]", represents the end of a branch, 
#   returns to the saved position. 
#   
#   Parameters:
#   -----------
#   gene: string
#         Segment of genetic information transmitted from one generation to the next
#
#   resultslocation: string 
#                    Location of the txt files folder including iteration_attempt_generation level
#
#   imglocation: string
#                Location of the images folder including iteration_attempt_generation level
#
#   Returns:
#   --------
#   genomehash: string
#               Hash value of the element. It identifies its filename.
#
##
function genomehash = LsystemGenerator(gene, resultslocation, imglocation)

    #constants
    replicationnum = 3;
    axiom = "G";
    
    logger.initSLF4O();
    phenotype = gene;
    
    for i=1:replicationnum
        try        
            phenotype = strrep(phenotype, axiom, gene);
        catch
            msg = lasterror.message;
            logger.error("LsystemGenerator: error: %s | gene: %s", msg, gene);
        end_try_catch
    endfor

    timeStart = tic();

    genomehash = tree(gene, phenotype, resultslocation, imglocation);

    timeEnd = toc(timeStart);
    logger.info("LsystemGenerator: Gene: %s | Elapsed time: %f", gene, timeEnd);

endfunction

##
# 
#   Function that generates the phenotype based on the genome applying
#   "turtle graphics" and the following rules:
# 
#   G = move n forward
#   - = turn left by angle
#   + = turn right by angle
#   [ = push position and angle
#   ] = pop position and angle
#   
#   The processing of the string works by checking char for char against the mentioned rules.
#   
#   Parameters:
#   -----------
#   gene: string
#         Segment of genetic information transmitted from one generation to the next
#
#   phenotype: string
#
#   resultslocation: string
#
#   imglocation: string
#
#   Returns:
#   --------
#   genomehash: String
#               Hash value of the element. It identifies its filename.
##
function genomehash = tree(genome, phenotype, resultslocation, imglocation)

    linewidth = 2;
    linecolor = "k";
    minimumlength = 0.001;
    # angle: '+' = rotate anticlockwise;
    #        '-' = rotate clockwise.
    alpha = -30; # degrees (angle)
    lengthGsegment = 1;
    stackpointer = 1;

    # turtle position and angle initialization
    xT = 0;
    yT = 0;
    aT = 0;
    da = alpha/180*pi; # convert deg to rad

    #bounding box initialization
    mx = 0;   # x min
    Mx = 0;   # x max
    my = 0;   # y min
    My = 0;   # y max

    #figure initialization
    plothandler = clf;
    grid off;
    axis off;
    hold on;

    for i = 1:length(phenotype)
        nucleotide = phenotype(i);
        switch nucleotide
            case "G"
                newxT = xT + lengthGsegment*cos(aT);
                newyT = yT + lengthGsegment*sin(aT);
                # plot characteristics of the line
                line([yT newyT], [xT newxT],'color',linecolor,'linewidth',linewidth);
                xT = newxT;
                yT = newyT;
            case "+" # rotate anticlockwise
                aT = aT + da;
            case "-" # rotate clockwise
                aT = aT - da;
            case "[" # save current position
                stack(stackpointer).xT = xT ;
                stack(stackpointer).yT = yT ;
                stack(stackpointer).aT = aT ;
                stackpointer = stackpointer +1 ;
            case "]" # return to former position (last save)
                stackpointer = stackpointer -1 ;
                xT = stack(stackpointer).xT ;
                yT = stack(stackpointer).yT ;
                aT = stack(stackpointer).aT ;
            otherwise
                disp("error: That value is not allowed");
                return
        end
        
        # bounding box update
        if (xT < mx) mx = xT; endif
        if (xT > Mx) Mx = xT; endif
        if (yT < my) my = yT; endif
        if (yT > My) My = yT; endif
        
    endfor

    # sets data aspect ratio 
    daspect([1,1,1]);

    if (abs(Mx) < minimumlength) Mx = 0; endif
    if (abs(mx) < minimumlength) mx = 0; endif
    if (abs(My) < minimumlength) My = 0; endif
    if (abs(my) < minimumlength) my = 0; endif

    # Both txt and svg files will have the same filename
    # Saving genome properties in txt file
    genomehash = getHash(genome); 

    if length(imglocation) != 0
        # saving figure as svg format
        imgfilenameroot = strcat(imglocation, filesep, genomehash);
        print(plothandler, "-dsvg", imgfilenameroot);

        # save as bmp
        print(plothandler, [imgfilenameroot, ".jpeg"], "-mono")
    endif

    if length(resultslocation) != 0
        txtfilenameroot = strcat(resultslocation, filesep, genomehash);
        save_header_format_string("");
        save(strcat(txtfilenameroot, ".txt"), "genome", "genomehash");

    endif

 
endfunction
