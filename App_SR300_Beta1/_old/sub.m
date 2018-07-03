while 1
    calllib('realsense', 'rs_wait_for_frames', app.dev, rs_error);
    rs_check_error(app.err);
    [depth_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev, app.rsEnum.rs_stream.RS_STREAM_DEPTH, rs_error);
    rs_check_error(app.err);
    depth_image.setdatatype('uint16Ptr', app.width*app.height);
    depth_image = depth_image.Value;
    depth_image = reshape(depth_image, [app.width, app.height]);
    depth_image = double(depth_image);
    [color_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev, app.rsEnum.rs_stream.RS_STREAM_COLOR, rs_error);
    rs_check_error(app.err);
    color_image.setdatatype('uint8Ptr', app.width*app.height*3);
    color_image = color_image.Value;
    color_image = reshape(color_image, 3, app.width, app.height);
    color_image = permute(color_image, [2,3,1]);
    clear f
    f.depth_image = depth_image;
    f.color_image = color_image;
    f.scale = app.scale;
    f.depth_intrin = app.depth_intrin;
    f.color_intrin = app.color_intrin;
    f.depth_to_color_extrinsics = app.depth_to_color;
    pc = CreatePointCloudMex(f);
    pcshow(pc); xlabel('x'); ylabel('y'); zlabel('z');
    view([0,0,-1]);
    drawnow
    if get(gcf,'CurrentCharacter') == 'c'
        pcwrite(pc,'pcl');
        set(gcf,'currentch','n');
    end
end