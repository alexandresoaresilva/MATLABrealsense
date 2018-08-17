function saveAllParameters(app)
    
    %for i=1:length(app.presentCamSelecOptTable(1,:))
    currentSelectOptions = cell(length(app.presentCamSelecOptTable(:,1)),4 );
    currentSelectOptions(:,1) = app.presentCamSelecOptTable(:,1) %indeces as within the SR300's libraries
    currentSelectOptions(:,2) = app.presentCamSelecOptTable(:,2) %cam name 'SR300' or 'F200' or else 
    currentSelectOptions(:,3) = app.presentCamSelecOptTable(:,3) %string with option RS_OPTION...
    currentSelectOptions(:,4) = app.presentCamSelecOptTable(:,6) %current option value
        
    rsoptions = fieldnames(app.rsEnum.rs_option);
    option = app.rsEnum.rs_option.(rsoptions{app.index});
    %retrieves value of currently selected parameter from camera
    [currentSelectOptions{app.index,4}, ~, app.err] = calllib('realsense',...
              'rs_get_device_option', app.dev{app.selectdev}, option, rs_error);
              rs_check_error(app.err);%retrieves current value for current selection from camera
    
    %filename = strcat('SavedParameters\',app.connctdShortCamNames{app.selectdev},'.Param.mat');
    filename = strcat(app.connctdShortCamNames{app.selectdev},'.Param.mat');
    uisave('currentSelectOptions',filename);
    %filename = strcat(app.folderSaved,app.paramfileName);
    %save(filename,'currentSelectOptions');
    
  
    
end

%% for loadSavedParameters
% 1. Checks if parameters match (camera selection, for instance)
% 2. applies new values into camera's parameters