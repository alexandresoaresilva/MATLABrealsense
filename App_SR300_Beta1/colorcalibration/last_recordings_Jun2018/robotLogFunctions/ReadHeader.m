function [version,numCameras] = ReadHeader(file)
    version = fread(file,1,'uint16=>double');
    numCameras = fread(file,1,'uint16=>double');
end