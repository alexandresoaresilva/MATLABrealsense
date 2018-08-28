function camColorCalibration(app)
    %apply color sharpness = 3 (8 is the option pointer to color sharpness
    %option pointers are the first element; second to last element are the
    %values to be tested
    
    %% these define values to cover in the parameters' loops 
    %parameters pointers applied to the C function call rs_set_device_option
    
    %% brightness(1) == C option pointer; brightnessess(2:end) == values to be applied
	%backlightCompensation = {0 0:1:3};
    brightness = {1 -32:16:32};
    contrast = {2 30:10:70};
    exposure = {3 -8:2:0};
	%gain = {4 60:2:70};
    gamma = {5 250:50:350};
    hue = {6 -14:7:14};
    colorSaturation = {7 50:25:75};
	%sharpness = {8 40:5:60};
	whiteBalance = {9 4000:600:4600};
	
	%backlightCompensation = {0 0:1:3};
	brightness = {1 -32:64:32};
    contrast = {2 30:40:70};
    exposure = {3 -8:8:0};
	%gain = {4 60:2:70};
    gamma = {5 250:100:350};
    hue = {6 -14:28:14};
    colorSaturation = {7 50:25:75};
	%sharpness = {8 40:5:60};
	whiteBalance = {9 4000:600:4600};
    

    run = 0;%num of runs
    %last one is error; run is first column; others have the option pointer
    %on the first row, and values for each run on the other rows
    %200 error on the first row so it's ignored by the program
    paramOptSets = {run,brightness{1},contrast{1},exposure{1},gamma{1},hue{1},colorSaturation{1},whiteBalance{1},200};
    
    %building 2d-cell  for values to be tested later
    for a=brightness{2:end} 
        for b=contrast{2:end}
            for c=exposure{2:end}
                for d=gamma{2:end} 
                    for e=hue{2:end} 
                        for f=colorSaturation{2:end}
                            for g=whiteBalance{2:end} 
                                %% saves the runs with error and parameters' values
                                run = run + 1;
                                paramOptSets{run+1,1} = run; %run+1 starts at the second row
                                paramOptSets{run+1,2} = a; %value for brightnessess
                                paramOptSets{run+1,3} = b; %contrast
                                paramOptSets{run+1,4} = c; %exposure
                                paramOptSets{run+1,5} = d; %gamma
                                paramOptSets{run+1,6} = e; %hue
                                paramOptSets{run+1,7} = f; %colorSaturation
                                paramOptSets{run+1,8} = g; %whiteBalance
                            end
                        end
                    end
                end
            end
        end
    end 
        %% turns off auto exposure,  auto white balance
        [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, 10, 0, rs_error); %auto exposure
        rs_check_error(app.err);
        
        [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, 11, 0, rs_error); %auto white bal
        rs_check_error(app.err);
    
 %% applying the settings to test for errors
    for i=2:length(paramOptSets)%starts from 2nd row (1st only has pointers)
        %brightnessESS - paramOptSets{1,2} for pointer
        %paramOptSets{i,2} for values
       [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, paramOptSets{1,2}, paramOptSets{i,2}, rs_error);
        rs_check_error(app.err);

        %CONTRAST - paramOptSets{1,3} for pointer
        %paramOptSets{i,3} for values
        [~, app.err] = calllib('realsense', 'rs_set_device_option',...
        app.dev{app.selectdev}, paramOptSets{1,3}, paramOptSets{i,3}, rs_error);
        rs_check_error(app.err);
        
        %EXPOSURE - paramOptSets{1,4} for pointer
        %paramOptSets{i,4} for values
        [~, app.err] = calllib('realsense',...
        'rs_set_device_option',app.dev{app.selectdev},...
        paramOptSets{1,4}, paramOptSets{i,4}, rs_error);
        rs_check_error(app.err);

        %GAMMA - paramOptSets{1,5} for pointer
        %paramOptSets{i,5} for values
        [~, app.err] = calllib('realsense',...
        'rs_set_device_option',app.dev{app.selectdev},...
        paramOptSets{1,5}, paramOptSets{i,5}, rs_error);
        rs_check_error(app.err);
        
        %HUE - paramOptSets{1,6} for pointer
        %paramOptSets{i,6} for values
        [~, app.err] = calllib('realsense','rs_set_device_option',...
            app.dev{app.selectdev}, paramOptSets{1,6},...
            paramOptSets{i,6}, rs_error);
        rs_check_error(app.err);
        
        %COLOR SATURATION - paramOptSets{1,7} for pointer
        %paramOptSets{i,7} for values
        [~, app.err] = calllib('realsense','rs_set_device_option',...
            app.dev{app.selectdev}, paramOptSets{1,7},...
            paramOptSets{i,7}, rs_error);
        rs_check_error(app.err);        
        
        %WHITE BALANCE - paramOptSets{1,8} for pointer
        %paramOptSets{i,8} for values
        [~, app.err] = calllib('realsense','rs_set_device_option',...
            app.dev{app.selectdev}, paramOptSets{1,7},...
            paramOptSets{i,7}, rs_error);
        rs_check_error(app.err);
        
        disp({'run ',paramOptSets{i,1}})
        
        colorFrameFetch(app); %updates frame
        
        paramOptSets{i,9} = calibrate(app); %percentual error in pic with the parameter applied
    end
	format short
	paramOptSets = cell2mat(paramOptSets(3:end,:));
	[smallestError, errorRow] = min(paramOptSets(:,9))
	optimalValues = int32(paramOptSets(errorRow, 2:8));
	optimalValues = horzcat({'brightness' ; 'contrast' ; 'exposure' ; 'gamma' ; 'hue' ; 'colorSaturation' ; 'whiteBalance'}, num2cell(optimalValues'))
	save(writeNewFileName('paramOptSets'), 'paramOptSets');
	save(writeNewFileName('optimalValues'), 'optimalValues');
end