    
        brightness = cell(1);
    contrast = cell(1);
    gamma = cell(1);
    hue = cell(1);
    colorSaturation = cell(1);
    
    brightness = 1;
    brightness = [brightness 20:5:60]
    
    contrast = 2;
    
    contrast = [contrast 16:4:32];
    
    gamma = 5;
    gamma = [gamma 230:10:280];
    
    
    hue = 6;
    hue = [hue 0:11];
    
    colorSaturation = 7;
    colorSaturation = [colorSaturation 144:2:156];
    
    
    runs = length(brightness(2:end))*length(contrast(2:end))...
        *length(gamma(2:end))*length(hue(2:end))....
        *length(colorSaturation(2:end))
    
        %paramOptSets = cell(1,1);
        run = 0;
        paramOptSets = cell(1,7);
    paramOptSets = {run,brightness(1),contrast(1),gamma(1),hue(1),colorSaturation(1),10000};
    
    paramOptSets(2,:) = {1,40,30,50,100,20,1};
    paramOptSets(3,:) = {1,40,30,50,100,20,150};
    %paramOptSets{2,3} = 10
   
   
    
   [errorFound,errorindex] = findSmallestError(paramOptSets)

    
    %errorindex = errorindex +1; %correcting it (1st line only has titles

    
    
function [runWihtSmallestError errRow] = findSmallestError(cellArrayWithParameters)
   
   [smallestError,errRow] = min(cell2mat(cellArrayWithParameters(:,7)))   
end