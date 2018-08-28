%  Read camera intrinsics from file
function [systemTime] = ReadSystemTime(file)
    %  Read values from file
    year = fread(file,1,'uint16=>double');
    month = fread(file,1,'uint16=>double');
    dayOfWeek = fread(file,1,'uint16=>double');
    day = fread(file,1,'uint16=>double');
    hour = fread(file,1,'uint16=>double');
    minute = fread(file,1,'uint16=>double');
    second = fread(file,1,'uint16=>double');
    milliseconds = fread(file,1,'uint16=>double');
    if feof(file)
        error('End of file while reading timestamp');
    end
    
    %  Create struct from values
    systemTime = struct('year',year,'month',month,'dayOfWeek',dayOfWeek,'day',day,'hour',hour,'minute',minute,'second',second,'milliseconds',milliseconds);
end