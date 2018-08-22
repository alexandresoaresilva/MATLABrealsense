width = 640; 
height = 480;
fps = 30;

RS_API_MAJOR_VERSION =  1;
RS_API_MINOR_VERSION = 12;
RS_API_PATCH_VERSION =  1;
RS_API_VERSION = (((RS_API_MAJOR_VERSION) * 10000) + ((RS_API_MINOR_VERSION) * 100) + (RS_API_PATCH_VERSION));

% loadlibrary('realsense', 'rs.h', ...
%             'mfilename', 'realsense');
loadlibrary('realsense', 'rs.h', ...
            'addheader','rsutil.h', ...
            'mfilename', 'realsense');
[methodinfo, structs, rsEnum, ThunkLibName] = realsense;
       
% libfunctionsview('realsense')
% unloadlibrary('realsense')

[ctx, err] = calllib('realsense', 'rs_create_context', RS_API_VERSION, rs_error());
rs_check_error(err);
[deviceCount, err]  = calllib('realsense', 'rs_get_device_count', ctx, rs_error());
rs_check_error(err); 
devIdx = 0;
[app.dev, err] = calllib('realsense', 'rs_get_device', ctx, devIdx, rs_error());
rs_check_error(err);

[devName, err] = calllib('realsense', 'rs_get_device_name', app.dev, rs_error());
rs_check_error(err);

[devSerial, err] = calllib('realsense', 'rs_get_device_serial', app.dev, rs_error());
rs_check_error(err);

streamColor = rsEnum.rs_stream.RS_STREAM_COLOR;
formatColor = rsEnum.rs_format.RS_FORMAT_RGB8;
[~, err] = calllib('realsense', 'rs_enable_stream', app.dev, streamColor, width, height, formatColor, fps, rs_error());
% [~, err] = calllib('realsense', 'rs_enable_stream_preset', app.dev, streamColor, rsEnum.rs_preset.RS_PRESET_BEST_QUALITY,  rs_error());
rs_check_error(err);

streamDepth = rsEnum.rs_stream.RS_STREAM_DEPTH;
formatDepth = rsEnum.rs_format.RS_FORMAT_Z16;
[~, err] = calllib('realsense', 'rs_enable_stream', app.dev, streamDepth, width, height, formatDepth, fps, rs_error());
% [~, err] = calllib('realsense', 'rs_enable_stream_preset', app.dev, streamDepth, rsEnum.rs_preset.RS_PRESET_BEST_QUALITY,  rs_error());

rs_check_error(err);

[~, err] = calllib('realsense', 'rs_start_device', app.dev, rs_error);
rs_check_error(err);

depth_intrin = libstruct('rs_intrinsics', struct());
[~, depth_intrin, err] = calllib('realsense', 'rs_get_stream_intrinsics', app.dev, streamDepth, depth_intrin, rs_error);
rs_check_error(err);

color_intrin = libstruct('rs_intrinsics', struct());
[~, color_intrin, err] = calllib('realsense', 'rs_get_stream_intrinsics', app.dev, streamColor, color_intrin, rs_error);
rs_check_error(err);

depth_to_color = libstruct('rs_extrinsics', struct());
[~, depth_to_color, err] = calllib('realsense', 'rs_get_device_extrinsics', app.dev, streamDepth, streamColor, depth_to_color, rs_error);
rs_check_error(err);

[scale, err] = calllib('realsense', 'rs_get_device_depth_scale', app.dev, rs_error);
rs_check_error(err);

files = dir('*.ply');

%the enxt statement make the names of files saved start form 1 if there are
%no PLY files in the folder
if ((~isempty(files)) && (fopen('pccount.mat') ~= -1)) %look for file
    load('pccount.mat','pccount');
    disp(['pccount = ',num2str(pccount),' has been loaded']);
    pause(2);% so we can read the variable being loaded
else
    pccount = 1;
end

%[app.dev, ~, ~, err] = calllib('realsense', 'rs_set_device_options', app.dev, uint32([0:4]), uint32(5), [1, 32, 75, -2, 120], rs_error);
%[app.dev, ~, ~, err] = calllib('realsense', 'rs_set_device_options', app.dev, uint32([0]), uint32(1), [1], rs_error);

% get device options list
app.rsoptions = fieldnames(rsEnum.rs_option);
app.dev_opt_desc = app.rsoptions;
rsoptionscount = numel(app.rsoptions);

app.dev_opt_current = zeros(rsoptionscount, 1);
app.opt_min = zeros(rsoptionscount, 1);
app.opt_max = zeros(rsoptionscount, 1);
app.opt_step = zeros(rsoptionscount, 1);
app.optsupported = zeros(rsoptionscount, 1);

for i = 1:rsoptionscount
    app.opt = app.rsoptions{i};

    %[app.dev, ~, err] = calllib('realsense', 'rs_reset_device_options_to_default', app.dev, app.opt, 1, rs_error);
    %rs_check_error(err);   
    
     
    [app.optsupported(i), ~, err] = calllib('realsense', 'rs_device_supports_option', app.dev, app.opt, rs_error);
    rs_check_error(err);

    [app.dev_opt_desc{i}, ~, err] = calllib('realsense', 'rs_get_device_option_description', app.dev, app.opt, rs_error);
    rs_check_error(err);

    [app.dev_opt_current(i), ~, err] = calllib('realsense', 'rs_get_device_option', app.dev, app.opt, rs_error);
    rs_check_error(err);

    [~, app.opt_min(i), app.opt_max(i), app.opt_step(i), err] = calllib( ...
        'realsense', 'rs_get_device_option_range', ...
         app.dev, app.opt, ...
         app.opt_min(i), app.opt_max(i), app.opt_step(i), ...
         rs_error);
    rs_check_error(err);
end

rsoptionstable = [app.rsoptions, app.dev_opt_desc, num2cell(app.dev_opt_current), num2cell(app.opt_min), ...
    num2cell(app.opt_max), num2cell(app.opt_step), num2cell(app.optsupported)];
	
