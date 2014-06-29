function [ SSD ] = SSD( L, R )
    % Provides the sum of the squared difference between
    % two matrices of the same size.
    % SSDmatrix = -(L-R).^2;
    intL = int16(L);
    intR = int16(R);
    SSDmatrix = (intL-intR);
    
    SSD = sumsqr(SSDmatrix);
    %SSDmatrix = SSDmatrix.^2;
    
    SSD = 0 - SSD;
end

