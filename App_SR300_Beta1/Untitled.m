brightness = [1 -32:16:32];
contrast = [2 30:10:70];
exposure = [3 -8:2:0];
%gain = [4 60:2:70];
gamma = [5 250:50:350];
hue = [6 -14:7:14];
colorSaturation = [7 50:25:75];
%sharpness = [8 40:5:60];
whiteBalance = [9 4000:600:4600];
    
    ((length(brightness)-1)*(length(contrast)-1)*(length(exposure)-1)*...
        (length(gamma)-1)*(length(hue)-1)*(length(colorSaturation)-1)...
        *(length(whiteBalance)-1))

