function stream_PCL(app, x, y)
    if isvalid(app.figpcl)
        calllib('realsense', 'rs_wait_for_frames', app.dev{app.selectdev}, rs_error);
        rs_check_error(app.err);
        [depth_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, app.rsEnum.rs_stream.RS_STREAM_DEPTH, rs_error);
        rs_check_error(app.err);
        %if isempty(depth_image)
        %    return;
        %end
        depth_image.setdatatype('uint16Ptr', app.width*app.height);
        depth_image = depth_image.Value;
        depth_image = reshape(depth_image, [app.width, app.height]);
        depth_image = double(depth_image);
        [color_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, app.rsEnum.rs_stream.RS_STREAM_COLOR, rs_error);
        rs_check_error(app.err);
        color_image.setdatatype('uint8Ptr', app.width*app.height*3);
        color_image = color_image.Value;
        color_image = reshape(color_image, 3, app.width, app.height);
        color_image = permute(color_image, [2,3,1]);
        clear f
        f.depth_image = depth_image;
        f.color_image = color_image;
        f.scale = app.scale{app.selectdev};
        f.depth_intrin = app.depth_intrin{app.selectdev};
        f.color_intrin = app.color_intrin{app.selectdev};
        f.depth_to_color_extrinsics = app.depth_to_color{app.selectdev};
        pc = CreatePointCloudMex(f);
        scatter3(pc.Location(:,1), pc.Location(:,2), pc.Location(:,3), 50, double(pc.Color)/255, '.', 'Parent', app.axpcl);
        %pcshow(pc, 'Parent', app.axpcl);
        xlim(app.axpcl, [-0.3 0.3]); ylim(app.axpcl, [-0.2 0.2]); zlim(app.axpcl, [-2 2]);
        xlabel(app.axpcl, 'x'); ylabel(app.axpcl, 'y'); zlabel(app.axpcl, 'z');
        view(app.axpcl, [0,0,-1]);
        drawnow
        if get(get(groot,'CurrentFigure'),'CurrentCharacter') == 'c'
            pcwrite(pc, strcat('pcl', num2str(app.countpcl), '.ply'));
            set(gcf,'currentch','n');
            app.countpcl = app.countpcl + 1;
        end
    end
end
%catch e
%   error = throw(e);
%end