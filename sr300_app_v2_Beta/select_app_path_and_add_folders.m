        %changes folder if the currently selected folder isn't the app's one
        %also adds folder to path so other scripts can be executed
function select_app_path_and_add_folders(app)
    currentFolder = pwd;
   % appName = mfilename;
    appName = strcat({'\'},mfilename); % added for getting rid of slash on the next statement
                                          %at the end of the full app path
    fullAppPath = mfilename('fullpath');
    app.appfullPath = erase(fullAppPath,appName);

    if ~strcmpi(currentFolder,app.appfullPath)
        %cd
        cd(app.appfullPath)
    end
    %addpath('colorcalibration');
    addpath('realsense_lib');
    addpath('setup_functions');
end