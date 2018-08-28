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
    colorSaturation = {colorSaturation 144:2:156};
    

    run = 0;%num of runs
    
    paramOptSets = cell(1,7);
    %last one is error; run is first column; others have the option pointer
    %on the first row, and values for each run on the other rows
    %10000 error on the first row so it's ignored by the program
    paramOptSets = {run,brightness(1),contrast(1),gamma(1),hue(1),colorSaturation(1),10000};
    
    %applies sharpness(8) 3
    [~, app.err] = calllib('realsense', 'rs_set_device_option',....
        app.dev{app.selectdev}, 8, 3, rs_error);
    rs_check_error(app.err);
    
    %applies color backlight compensation(0) 0
    [~, app.err] = calllib('realsense', 'rs_set_device_option',....
        app.dev{app.selectdev}, 0, 0, rs_error);
    rs_check_error(app.err);
    
    %stop(app.timercolor);
    if ~app.colorstreamButton.Value
        app.colorstreamButton.Value = 1;
    %    colorstreamButtonValueChanged(app,app.colorstreamButton.Value);
    end
    for a=brightness{2:end} %BRIGHTNESS
        [~, app.err] = calllib('realsense', 'rs_set_device_option',...
            app.dev{app.selectdev}, brightness{1}, a, rs_error);
        rs_check_error(app.err);
        
        for b=contrast{2:end}
            [~, app.err] = calllib('realsense', 'rs_set_device_option',...
                app.dev{app.selectdev}, contrast{1}, b, rs_error);
                rs_check_error(app.err);
            for c=gamma{2:end} %BRIGHTNESS
                [~, app.err] = calllib('realsense',...
                    'rs_set_device_option',app.dev{app.selectdev},...
                    gamma{1}, c, rs_error);
                rs_check_error(app.err);
                
                for d=hue{2:end} %BRIGHTNESS
                    [~, app.err] = calllib('realsense',...
                        'rs_set_device_option',app.dev{app.selectdev},...
                        hue{1}, d, rs_error);
                    rs_check_error(app.err);
                    
                    for e=colorSaturation{2:end} %BRIGHTNESS
                        [~, app.err] = calllib('realsense',...
                            'rs_set_device_option',...
                            app.dev{app.selectdev}, colorSaturation{1}, e, rs_error);
                        rs_check_error(app.err);
                        %% saves the runs with error and parameters' values
                        run = run + 1;
                        paramOptSets{run+1,1} = run; %run+1 starts at the second row
                        paramOptSets{run+1,2} = a; %value for brightness
                        paramOptSets{run+1,3} = b; %contrast
                        paramOptSets{run+1,4} = c; %gamma
                        paramOptSets{run+1,5} = d; %hue
                        paramOptSets{run+1,6} = e; %colorSaturation
                        %paramOptSets{run+1,5} = d; %gamma
                        paramOptSets{run+1,7} = calibrate(app); %percentual error in pic with the parameter applied
                        app.colorstreamButton.Value = 0;
         %               colorstreamButtonValueChanged(app,app.colorstreamButton.Value);
                    end
                end
            end
        end
        app.colorstreamButton.Value = 1;
        %colorstreamButtonValueChanged(app,app.colorstreamButton.Value);
    end
    
    [~,errorRow] = findSmallestError(paramOptSets);
    
    paramOptSets
    %applying brightness setting
    [~, app.err] = calllib('realsense', 'rs_set_device_option', app.dev{app.selectdev}, brightness{1}, paramOptSets{errorRow,2}, rs_error);
    rs_check_error(app.err);
    
    %applying gamma setting
    [~, app.err] = calllib('realsense', 'rs_set_device_option', app.dev{app.selectdev}, gamma{1}, paramOptSets{errorRow,4}, rs_error);
    rs_check_error(app.err); 
end

function [runWihtSmallestError errRow] = findSmallestError(cellArrayWithParameters)
   
   [runWihtSmallestError,errRow] = min(cell2mat(cellArrayWithParameters(:,7)))   
end