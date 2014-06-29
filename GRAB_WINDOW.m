function [ window ] = GRAB_WINDOW( imageMatrixBW, thisCol, thisRow, size, scale)
    % Grab a greyscale square window of width and height 'size'
    % from image 'imageFilename' beginning at 
    % co-ordinates 'x, y'     
    % matrix=imread(imageFilename);
    % matrix = .2989*matrix(:,:,1) +.5870*matrix(:,:,2) +.1140*matrix(:,:,3);
    % crop width
    width = scale * size;
    width = width - 1; 
    window = imageMatrixBW(:,thisCol:thisCol+width);
    % crop height    
    window = window(thisRow:thisRow+size-1,:);
end


