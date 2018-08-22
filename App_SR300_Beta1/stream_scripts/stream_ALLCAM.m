function stream_ALLCAM(app, x, y)

    if isvalid(app.figall)
        for i = 1:app.deviceCount
            %wait for frames
            calllib('realsense', 'rs_wait_for_frames', app.dev{i}, rs_error);
            rs_check_error(app.err);
            %color frame
            [color_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{i}, ...
                app.rsEnum.rs_stream.RS_STREAM_COLOR, rs_error);
            rs_check_error(app.err);
            color_image.setdatatype('uint8Ptr', app.width*app.height*3);
            color_image = color_image.Value;
            color_image = reshape(color_image, 3, app.width, app.height);
            color_image = permute(color_image, [2,3,1]);
            color_image = rot90(color_image,-1);
            imagesc(app.axall{i}, color_image);
            axis(app.axall{i},'image');
            RGB_title = app.TabCamSelected(app.selectdev).Title;
            title(app.axall{i}, ['RGB stream ', RGB_title]);

            drawnow;
            %depth frame
            [depth_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{i}, ...
                app.rsEnum.rs_stream.RS_STREAM_DEPTH, rs_error);
            rs_check_error(app.err);
            depth_image.setdatatype('uint16Ptr', app.width*app.height);
            depth_image = depth_image.Value;
            depth_image = reshape(depth_image, [app.width, app.height]);
            depth_image = double(depth_image);
            depth_image = rot90(depth_image,-1);
            image(app.axall{i + app.deviceCount}, depth_image/2^15*255);
            Depth_title = app.TabCamSelected(app.selectdev).Title;
            title(app.axall{i + app.deviceCount}, ['Depth stream ', Depth_title]);
            
            %colormap hot;
            colormap gray;
            axis(app.axall{i + app.deviceCount},'image');
            drawnow;
        end
    end
end