function [ out ] = rs_check_error( err )
    out = calllib('realsense', 'rs_get_error_message',  err);
    if ~isempty(out)
        disp(out);
    end
end

