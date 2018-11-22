function stream_DEPTH(app, x, y)
    calllib('realsense', 'rs_wait_for_frames', app.dev{app.selectdev}, rs_error);
    rs_check_error(app.err);
    %depth frame
    [depth_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, ...
        app.rsEnum.rs_stream.RS_STREAM_DEPTH, rs_error);
    rs_check_error(app.err);
    depth_image.setdatatype('uint16Ptr', app.width*app.height);
    depth_image = depth_image.Value;
    depth_image = reshape(depth_image, [app.width, app.height]);
    depth_image = double(depth_image);
    depth_image = rot90(depth_image,-1);
    image(app.axdepth, depth_image/2^15*255);
    %Depth_title = app.TabCamSelected(app.selectdev).Title;
    %title(app.axdepth, ['Depth stream ', Depth_title]);
    
    title(app.axdepth, app.DEPTH_title);

    colormap gray;
    axis(app.axdepth,'image');
    drawnow;
    if get(get(groot,'CurrentFigure'),'CurrentCharacter') == 'c'
        imwrite(depth_image, strcat('depth', num2str(app.countdepth), '.jpg'));
        set(gcf,'currentch','n');
        app.countdepth = app.countdepth + 1;
    end
end