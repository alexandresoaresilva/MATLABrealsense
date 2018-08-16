function LAB = correctcolor(calcos, RGB) 
    %RGB are arrays of integers 0-255 X elements long, calcos is 7x3 matrix 
    %LAB is 2d array of floating-point values 10 elements long, one column for each equation
    RGB = double(reshape(RGB(:), [], 3));
    n = size(RGB, 1);
    vals = [ones(n, 1), RGB, RGB.^2, RGB.^3];
    calcosL = calcos(:, 1)';
    calcosA = calcos(:, 2)';
    calcosB = calcos(:, 3)';
    
    calcosL = repmat(calcosL, size(vals,1), 1);
    calcosA = repmat(calcosA, size(vals,1), 1);
    calcosB = repmat(calcosB, size(vals,1), 1);
    
    L = sum(vals .* calcosL, 2);
    A = sum(vals .* calcosA, 2);
    B = sum(vals .* calcosB, 2);
    
    LAB = [L, A, B];
    
    
end