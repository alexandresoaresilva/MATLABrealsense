function setdeviceoptions(app)
    for i = 1:length(app.ivcamopts)
       [~, app.err] = calllib('realsense', 'rs_set_device_option', ...
           app.dev{app.selectdev}, app.ivcamopts(i),...
           app.ivcamoptvals(i), rs_error);
       rs_check_error(app.err);
    end
end