clc
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
            'mfilename', 'realsense');
[methodinfo, structs, rsEnum, ThunkLibName] = realsense;
       
% libfunctionsview('realsense')
% unloadlibrary('realsense')
% return

[ctx, err] = calllib('realsense', 'rs_create_context', RS_API_VERSION, rs_error());
rs_check_error(err);
[deviceCount, err]  = calllib('realsense', 'rs_get_device_count', ctx, rs_error());
rs_check_error(err); 
devIdx = 0;
[dev, err] = calllib('realsense', 'rs_get_device', ctx, devIdx, rs_error());
rs_check_error(err);

[devName, err] = calllib('realsense', 'rs_get_device_name', dev, rs_error());
rs_check_error(err);

[devSerial, err] = calllib('realsense', 'rs_get_device_serial', dev, rs_error());
rs_check_error(err);

streamColor = rsEnum.rs_stream.RS_STREAM_COLOR;
formatColor = rsEnum.rs_format.RS_FORMAT_RGB8;
[~, err] = calllib('realsense', 'rs_enable_stream', dev, streamColor, width, height, formatColor, fps, rs_error());
% [~, err] = calllib('realsense', 'rs_enable_stream_preset', dev, streamColor, rsEnum.rs_preset.RS_PRESET_BEST_QUALITY,  rs_error());
rs_check_error(err);

streamDepth = rsEnum.rs_stream.RS_STREAM_DEPTH;
formatDepth = rsEnum.rs_format.RS_FORMAT_Z16;
[~, err] = calllib('realsense', 'rs_enable_stream', dev, streamDepth, width, height, formatDepth, fps, rs_error());
% [~, err] = calllib('realsense', 'rs_enable_stream_preset', dev, streamDepth, rsEnum.rs_preset.RS_PRESET_BEST_QUALITY,  rs_error());


rs_check_error(err);

[~, err] = calllib('realsense', 'rs_start_device', dev, rs_error);
rs_check_error(err);

depth_intrin = libstruct('rs_intrinsics', struct());
[~, depth_intrin, err] = calllib('realsense', 'rs_get_stream_intrinsics', dev, streamDepth, depth_intrin, rs_error);
rs_check_error(err);

color_intrin = libstruct('rs_intrinsics', struct());
[~, color_intrin, err] = calllib('realsense', 'rs_get_stream_intrinsics', dev, streamColor, color_intrin, rs_error);
rs_check_error(err);

depth_to_color = libstruct('rs_extrinsics', struct());
[~, depth_to_color, err] = calllib('realsense', 'rs_get_device_extrinsics', dev, streamDepth, streamColor, depth_to_color, rs_error);
rs_check_error(err);

[scale, err] = calllib('realsense', 'rs_get_device_depth_scale', dev, rs_error);
rs_check_error(err);


% [dev, frameColorCallback, err] = calllib('realsense', 'rs_set_frame_callback_cpp', dev, streamColor, frameColorCallback, rs_error());


sub

















