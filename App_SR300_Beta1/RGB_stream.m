function RGB_stream(app, x, y)
%try
    if isvalid(app.figcolor{app.selectdev})
        calllib('realsense', 'rs_wait_for_frames', app.dev{app.selectdev}, rs_error);
        rs_check_error(app.err);
        %color frame
        %RS_STREAM
        [color_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, ...
            app.rsEnum.rs_stream.RS_STREAM_COLOR, rs_error);
        rs_check_error(app.err);
        color_image.setdatatype('uint8Ptr', app.width*app.height*3);
        color_image = color_image.Value;
        color_image = reshape(color_image, 3, app.width, app.height);
        color_image = permute(color_image, [2,3,1]);
        color_image = rot90(color_image,-1);

        app.calimage = color_image;
        imagesc(app.axcolor{app.selectdev}, color_image);
        RGB_title = app.TabCamSelected(app.selectdev).Title;
        title(['RGB stream ', RGB_title]);
        rectangle(app.axcolor{app.selectdev}, 'Position', [106, 80, 427, 320], 'EdgeColor', 'r', 'LineWidth', 3);
        viscircles(app.axcolor{app.selectdev}, fliplr(app.colorcoords.colorcoords),  ones(24, 1) .* 10);
        axis(app.axcolor{app.selectdev}, 'image');
        drawnow;

        if get(get(groot,'CurrentFigure'),'CurrentCharacter') == 'c'
            imwrite(color_image, strcat('color', num2str(app.countcolor), '.png'));
            set(gcf,'currentch','n');
            app.countcolor = app.countcolor + 1;
        end
    end
end
%catch e
%   error = throw(e);
%end