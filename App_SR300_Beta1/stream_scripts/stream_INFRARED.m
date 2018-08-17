function stream_INFRARED(app, x, y)
    if isvalid(app.figIR)
        calllib('realsense', 'rs_wait_for_frames', app.dev{app.selectdev}, rs_error);
        rs_check_error(app.err);
        %color frame
        %RS_STREAM_INFRARED
        [IR_image, ~, app.err] = calllib('realsense', 'rs_get_frame_data', app.dev{app.selectdev}, ...
            app.rsEnum.rs_stream.RS_STREAM_INFRARED, rs_error);
        rs_check_error(app.err);
        IR_image.setdatatype('uint8Ptr', app.width*app.height*1);
        IR_image = IR_image.Value;
        IR_image = reshape(IR_image, app.width, app.height);
        %IR_image = permute(IR_image, [2,3,1]);
        IR_image = rot90(IR_image,-1);

        %app.calimage = IR_image;
        imagesc(app.axIR, IR_image);
        IR_title = app.TabCamSelected(app.selectdev).Title;
        title(['IR stream ', IR_title]);
        axis(app.axIR, 'image');
        drawnow;

        if get(get(groot,'CurrentFigure'),'CurrentCharacter') == 'c'
            imwrite(IR_image, strcat('IR', num2str(app.countIR), '.png'));
            set(gcf,'currentch','n');
            app.countIR = app.countIR + 1;
        end
    end
end