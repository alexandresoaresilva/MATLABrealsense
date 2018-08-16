function colorFrameFetch(app)
%try
calllib('realsense', 'rs_wait_for_frames', app.dev{app.selectdev}, rs_error);
rs_check_error(app.err);
%color frame
[color_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, ...
    app.rsEnum.rs_stream.RS_STREAM_COLOR, rs_error);
rs_check_error(app.err);
color_image.setdatatype('uint8Ptr', app.width*app.height*3);
color_image = color_image.Value;
color_image = reshape(color_image, 3, app.width, app.height);
color_image = permute(color_image, [2,3,1]);
color_image = rot90(color_image,-1);
app.calimage = color_image;
%imagesc(app.axcolor, color_image);
%rectangle(app.axcolor, 'Position', [106, 80, 427, 320], 'EdgeColor', 'r', 'LineWidth', 3);
%viscircles(app.axcolor, fliplr(app.colorcoords.colorcoords),  ones(24, 1) .* 10);
%axis(app.axcolor, 'image');
%drawnow;

end
%catch e
%   error = throw(e);
%end