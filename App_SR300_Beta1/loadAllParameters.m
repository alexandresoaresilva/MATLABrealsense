function loadAllParameters(app)
    uiopen('mat');
    %[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle,DefaultName)
    
    if ( exist('currentSelectOptions') ~= 1 )
        errordlg({'This is not a parameter''s file';'Please, try again'});
    elseif ~strcmp(currentSelectOptions{1,2}, app.connctdShortCamNames{app.selectdev})
        parCam = currentSelectOptions(1,2)
        selecCam = app.connctdShortCamNames(app.selectdev);
        warnMsg = strcat({'Parameters not compatible with '},selecCam);
        warnMsg = strcat(warnMsg,{'; use a '},parCam,{' or try again with a different file.'});
        warndlg(warnMsg);
    else
        %warndlg({'THIS IS A TEST';'NO paramaters have been loaded'});
        
   
        % /**
        %  * efficiently set the value of an arbitrary number of options, using minimal hardware IO
        %  * \param[in] options  the array of options which should be set
        %  * \param[in] count    the length of the options and values arrays
        %  * \param[in] values   the array of values to which the options should be set
        %  * \param[out] error   if non-null, receives any error that occurs during this call, otherwise, errors are ignored
        %  */
       
       % savedParamPrt = libpointer('int16Ptr',485);
        %this one is for default values; modify it for saved ones
        
        %applies first auto exposure and auto white balance control
        %parameters, then follows with others - hard coded 11, 12 (10, 11)
        %but could be searched with string find later
        for i=11:12
            optPrt = currentSelectOptions{i,1}-1;
            [~, app.err] = calllib('realsense',...
                'rs_set_device_option', app.dev{app.selectdev},...
                optPrt, currentSelectOptions{i,4}, rs_error);
            
                rs_check_error(app.err);
        end %exposure and WHITE BALANCE GO BACK TO DEFAULT, NO MATTER WHAT, WITH THE F200
                
        for i = 1:(length(currentSelectOptions(:,1))-2) %-2 so it doesn't go up to framerate etc
            optPrt = currentSelectOptions{i,1}-1;
            [~, app.err] = calllib('realsense',....
                'rs_set_device_option', app.dev{app.selectdev},...
                optPrt, currentSelectOptions{i,4}, rs_error);
                rs_check_error(app.err);
        end
        %GetOptions(app);
        
        %applies ivcam parameters
        
%         ivcamPreset = currentSelectOptions(1,5:19);
%         
%         for i = 1:length(app.ivcamopts)
%            [~, app.err] = calllib('realsense', 'rs_set_device_option', app.dev{app.selectdev}, app.ivcamopts(i), app.ivcamoptvals(i), rs_error);
%            rs_check_error(app.err);
%         end
        
    end
    
    
end