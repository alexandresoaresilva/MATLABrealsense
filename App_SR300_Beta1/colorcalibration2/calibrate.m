function errorig = calibrate(app)
%wrapper for correctcolor, calibratecolor that corrects image and displays
%percent error
image = app.calimage;
load('LABreference.mat');
load('RGBreference.mat');
%sample colors
RGB = zeros(24, 3);
for i = 1:24
    RGB(i, :) = image(app.colorcoords.colorcoords(i, 1), app.colorcoords.colorcoords(i, 2), :);
end

calcos = calibratecolor(LABREF, RGB);
calcosref = calibratecolor(LABREF, RGBREF);
imagecorLAB = correctcolor(calcos, image);
LABCOR = correctcolor(calcos, RGB);
LABCORREF = correctcolor(calcosref, RGBREF);
RGBCOR = double(lab2rgb(LABCOR, 'OutputType', 'uint8'));
RGBCORREF = double(lab2rgb(LABCORREF, 'OutputType', 'uint8'));

% arrayfun
% for i = 1:size(imagecorRGB, 1)
%     imagecorRGB(i, 1:3) = lab2rgb(imagecorLAB(i, :), 'OutputType', 'uint8');
% end
imagecorRGB = double(lab2rgb(imagecorLAB, 'OutputType', 'uint8'));

errorig = sum(abs(RGBREF(:) - RGB(:))) / (3 * 24);

%errcor = sum(abs(RGBREF(:) - RGBCOR(:))) / (3 * 24);
%errcorref = sum(abs(RGBREF(:) - RGBCORREF(:))) / (3 * 24);
fprintf('Percent error in original: %d\n', errorig);

%fprintf('Percent error in correction: %d\n', errcor);
%fprintf('Percent error in calibration: %d\n', errcorref);
%height = size(image, 1);
%width = size(image, 2);
%imagecor = uint8(reshape(imagecorRGB(:), height, width, 3));
%imagesc(app.axcalcorr, imagecor);
%axis(app.axcalcorr, 'image');
%imagesc(app.axcalorig, image);
%axis(app.axcalorig, 'image');