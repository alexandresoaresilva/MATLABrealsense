function stream_RGB(app, x, y)
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
		app.color_calibrate_img = color_image;
        imagesc(app.axcolor{app.selectdev}, color_image);
        axis(app.axcolor{app.selectdev}, 'image');
        title(app.axcolor{app.selectdev}, app.RGB_title);
        drawnow; 
        
        %RGB_title = app.TabCamSelected(app.selectdev).Title;
            

        if get(get(groot,'CurrentFigure'),'CurrentCharacter') == 'c'
            imwrite(color_image, strcat('color', num2str(app.countcolor), '.png'));
            set(gcf,'currentch','n');
            app.countcolor = app.countcolor + 1;
        end
        
	end
end