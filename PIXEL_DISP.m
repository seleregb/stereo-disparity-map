function [ dispMap ] = PIXEL_DISP( imageLfilename, imageRfilename, imageOut, BWconvert, plot, scanWinSize, searchScale )
    
    % first, get both full-size images in grayscale if need be
    if (~BWconvert)
        matrixL = imread(imageLfilename);
        matrixR = imread(imageRfilename);
    end
    if (BWconvert)
        matrixL = rgb2gray(imread(imageLfilename));
        matrixR = rgb2gray(imread(imageRfilename));
    end   
    % for all pixes in left window  
    lastRow = -1;
    maxRows = 1 + size(matrixL, 1) - scanWinSize;
    maxCols = 1 + size(matrixL, 2) - scanWinSize;
    for row = 1: maxRows
        for col = 1: maxCols  
            % get left window - current position
            if (lastRow ~= row)
                output = ['Processing Row ',num2str(row), ' of ', num2str(maxRows)];
                disp(output);
                lastRow = row;
            end            
            WL = GRAB_WINDOW(matrixL, col, row, scanWinSize, 1);      
            % get right support window stats
            WRwidth = scanWinSize*searchScale;            
            WRlargeX = col - (scanWinSize * ((searchScale-1)/2)) - ((scanWinSize-1)/2);  
            WRlargeY = row ;
            if (WRlargeX < 1)
                WRlargeX = 1;
            end           
            if (WRlargeX > 1 + size(matrixL, 2) - WRwidth)
                WRlargeX = 1 + size(matrixL, 2) - WRwidth;
            end
            if (WRlargeY < 1)
                WRlargeY = 1;
            end
            if (WRlargeY > 1 + size(matrixL, 1) - WRwidth)
                WRlargeY = 1 + size(matrixL, 1) - WRwidth;
            end   
            % get large support window B&W           
            WRlarge = GRAB_WINDOW(matrixR, WRlargeX, WRlargeY, scanWinSize, searchScale);             
            % for each pixel in large window   
            matchX = 1;
            maxDisp = -9999999;
            arrWidth = (searchScale * scanWinSize) - (scanWinSize -1 );
            xMid = ((arrWidth - 1) / 2) + 1;
            for yrCurr = 1 : 1 + (size(WRlarge, 1) -scanWinSize)
                for xrCurr = 1 : 1 + (size(WRlarge, 2) - scanWinSize)
                    % get right search window
                    matRsupp = GRAB_WINDOW(WRlarge, xrCurr, yrCurr, scanWinSize, 1);                    
                    tempDisp = SUPPORT_CMP(WL, matRsupp);                    
                    % DECLUTTER - apply bias of similar values towards centre pixel choice                    
                    % xVector = xrCurr - xMid + (2 * (xMid - xrCurr));
                    % tempDisp = tempDisp - (32*xVector);                
                    % disparityFigures(yrCurr, xrCurr) = tempDisp + (32*xVector);
                    % disparityFigures(yrCurr, xrCurr) = tempDisp;
                    if (tempDisp > maxDisp)
                        maxDisp = tempDisp;
                        matchX = xrCurr;   
                    end
                end
            end 
            xVector = matchX - xMid + (2 * (xMid - matchX));
            mappedVal = (255 / (xMid -1)) * abs(xVector);            
            dispMap(row, col, 1) = uint8(mappedVal);
        end
    end  
    if (plot)
        surf(double(dispMap));
    end    
    imwrite(dispMap(:,:,1),imageOut,'GIF');
end

