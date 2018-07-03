clc

% 
% opt = rsEnum.rs_option.RS_OPTION_COLOR_EXPOSURE;
% 
% [dev_opt_desc, ~, err] = calllib('realsense', 'rs_get_device_option_description', dev, opt, rs_error);
% rs_check_error(err);
% 
% [dev_opt_current, ~, err] = calllib('realsense', 'rs_get_device_option', dev, opt, rs_error);
% rs_check_error(err);
% 
% opt_min = 0; opt_max = 0; opt_step = 0;
% [~, opt_min, opt_max, opt_step, err ] = calllib( ...
%     'realsense', 'rs_get_device_option_range', ...
%     dev, opt, ...
%     opt_min, opt_max, opt_step, ...
%     rs_error);
% 
% dev_opt_value = 0;
% 
% [~, err ] = calllib( ...
%     'realsense', 'rs_set_device_option', ...
%     dev, opt, ...
%     dev_opt_value, ...
%     rs_error);
% 
% dev_opt_desc
% dev_opt_current
% opt_min
% opt_max
% opt_step
% 
% [~, err ] = calllib( ...
%     'realsense', 'rs_set_device_option', ...
%     dev, rsEnum.rs_option.RS_OPTION_COLOR_ENABLE_AUTO_EXPOSURE, ...
%     1, ...
%     rs_error);


while 1
    calllib('realsense', 'rs_wait_for_frames', dev, rs_error);
    rs_check_error(err);
    
    disp('mark');
    [depth_image, ~, err] = calllib('realsense', 'rs_get_frame_data', dev, streamDepth, rs_error);
    rs_check_error(err);
    depth_image.setdatatype('uint16Ptr', width*height);
    depth_image = depth_image.Value;
    depth_image = reshape(depth_image, [width, height]);
    depth_image = double(depth_image);
%     figure(1); imagesc(imrotate(depth_image, 90)); axis equal;

    [color_image, ~, err] = calllib('realsense', 'rs_get_frame_data', dev, streamColor, rs_error);
    rs_check_error(err);
    color_image.setdatatype('uint8Ptr', width*height*3);
    color_image = color_image.Value;
    color_image = reshape(color_image, 3, width, height);
    color_image = permute(color_image, [2,3,1]);
%     figure(2); imagesc(imrotate(color_image, 90)); axis equal;
    
%     drawnow
%     continue

    clear f
    f.depth_image = depth_image;
    f.color_image = color_image;
    f.scale = scale;
    f.depth_intrin = depth_intrin;
    f.color_intrin = color_intrin;
    f.depth_to_color_extrinsics = depth_to_color;
    pc = CreatePointCloudMex(f);
    pcshow(pc); xlabel('x'); ylabel('y'); zlabel('z');
    view([0,0,-1]);
    drawnow
    
end
