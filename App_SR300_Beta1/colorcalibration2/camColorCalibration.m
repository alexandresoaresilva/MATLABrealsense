function camColorCalibration(app)
    %apply color sharpness = 3 (8 is the option pointer to color sharpness
    %option pointers:
        %color backlight compensation = 0
        %color brightness = 1
        %color contrast = 2;
        %color gamma = 5;
        %hue = 6;
        %color saturation = 7;
    %option pointers are the first element; second to last element are the
    %values to be tested
    
    %% these define values to cover in the parameters' loops 
    %parameters pointers applied to the C function call rs_set_device_option
    brightness = cell(1);
    contrast = cell(1);
    gamma = cell(1);
    hue = cell(1);
    colorSaturation = cell(1);
    
    %% brightness(1) == C option pointer; brightness(2:end) == values to be applied
    % all the parameters work the way describeb above
    brightness = 1;
    brightness = {brightness 20:5:60};
    
    contrast = 2;
    contrast = {contrast 16:2:32};
    
    gamma = 5;
    gamma = {gamma 230:10:280};
    
    
    hue = 6;
    hue = {hue 0:11};
    
    colorSaturation = 7;
    colorSaturation = {colorSaturation 144:4:156};
    

    run = 0;%num of runs
    
    paramOptSets = cell(1,7);
    %last one is error; run is first column; others have the option pointer
    %on the first row, and values for each run on the other rows
    %10000 error on the first row so it's ignored by the program
    paramOptSets = {run,brightness(1),contrast(1),gamma(1),hue(1),colorSaturation(1),10000};
    
    %building 2d-cell  for values to be tested later
    for a=brightness{2:end} 
        for b=contrast{2:end}
            for c=gamma{2:end} 
                for d=hue{2:end} 
                    for e=colorSaturation{2:end} 
                        %% saves the runs with error and parameters' values
                        run = run + 1;
                        paramOptSets{run+1,1} = run; %run+1 starts at the second row
                        paramOptSets{run+1,2} = a; %value for brightness
                        paramOptSets{run+1,3} = b; %contrast
                        paramOptSets{run+1,4} = c; %gamma
                        paramOptSets{run+1,5} = d; %hue
                        paramOptSets{run+1,6} = e; %colorSaturation
                        %paramOptSets{run+1,5} = d; %gamma
                        %app.colorstreamButton.Value = 0;
                    end
                end
            end
        end
    end
    

%applies sharpness(8) 3
        [~, app.err] = calllib('realsense', 'rs_set_device_option',....
            app.dev{app.selectdev}, 8, 3, rs_error);
        rs_check_error(app.err);

        %applies color backlight compensation(0) 0
        [~, app.err] = calllib('realsense', 'rs_set_device_option',....
            app.dev{app.selectdev}, 0, 0, rs_error);
        rs_check_error(app.err);
    
    %% applying the settings to test for errors
    for i=2:length(paramOptSets)%starts from 2nd row (1st only has pointers)
        %BRIGHTNESS - paramOptSets{1,2} for pointer
        %paramOptSets{i,2} for values
       [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, brightness{1}, paramOptSets{i,2}, rs_error);
        rs_check_error(app.err);

        %CONTRAST - paramOptSets{1,3} for pointer
        %paramOptSets{i,3} for values
        [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, contrast{1}, paramOptSets{i,3}, rs_error);
        rs_check_error(app.err);

        %GAMMA - paramOptSets{1,4} for pointer
        %paramOptSets{i,4} for values
        [~, app.err] = calllib('realsense',...
        'rs_set_device_option',app.dev{app.selectdev},...
        gamma{1}, paramOptSets{i,4}, rs_error);
        rs_check_error(app.err);
        
        %HUE - paramOptSets{1,5} for pointer
        %paramOptSets{i,5} for values
        [~, app.err] = calllib('realsense',...
        'rs_set_device_option',app.dev{app.selectdev},...
        hue{1}, paramOptSets{i,5}, rs_error);
        rs_check_error(app.err);
        
        %COLOR SATURATION - paramOptSets{1,6} for pointer
        %paramOptSets{i,6} for values
        [~, app.err] = calllib('realsense','rs_set_device_option',...
            app.dev{app.selectdev}, colorSaturation{1},...
            paramOptSets{i,6}, rs_error);
        rs_check_error(app.err);
        disp({'run ',paramOptSets{i,1}})
        colorFrameFetch(app); %updates frame
        paramOptSets{i,7} = calibrate(app); %percentual error in pic with the parameter applied
    end
    
 [~,errorRow] = findSmallestError(paramOptSets)
    

    
 
  
 

    
    %applying brightness setting
    %[~, app.err] = calllib('realsense', 'rs_set_device_option', app.dev{app.selectdev}, brightness{1}, paramOptSets{errorRow,2}, rs_error);
   % rs_check_error(app.err);
    
    %applying gamma setting
    %[~, app.err] = calllib('realsense', 'rs_set_device_option', app.dev{app.selectdev}, gamma{1}, paramOptSets{errorRow,4}, rs_error);
    %rs_check_error(app.err); 
end

function [runWihtSmallestError errRow] = findSmallestError(cellArrayWithParameters)
   
   [runWihtSmallestError,errRow] = min(cell2mat(cellArrayWithParameters(:,7)))
end