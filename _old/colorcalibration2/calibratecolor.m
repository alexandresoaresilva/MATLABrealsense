function calcos = calibratecolor(LAB, RGB) 
    %RGB are arrays of integers 0-255 24 elements long, calcos is 7x3 matrix 
    %LAB is 2d array of floating-point values 10 elements long, one column for each equation
    vals = [ones(24, 1), RGB, RGB.^2, RGB.^3];
    calcosL = regress(LAB(:, 1), vals);
    calcosA = regress(LAB(:, 2), vals);
    calcosB = regress(LAB(:, 3), vals);
    calcos = [calcosL, calcosA, calcosB];
end