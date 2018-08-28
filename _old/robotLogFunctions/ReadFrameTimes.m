function [times] = ReadFrameTimes(file_path, headerVersion, cameraIdx)
    
    recordingFile = fopen(file_path);
    fileInfo = dir(file_path);
    fileSize = fileInfo.bytes;
    numelFramesInFilePerCamera = floor(fileSize/frameSize(headerVersion)/3);

    times = cell(numelFramesInFilePerCamera,1);
    
    for i = 1:numelFramesInFilePerCamera
        %  Read frame info
        if headerVersion >= 2
            numelCameras = 3;
            framePosition = 4+frameSize(headerVersion)*((i-1)*numelCameras+cameraIdx);
            fseek(recordingFile, framePosition, 'bof');
            camera = fread(recordingFile,1,'uint16=>double');
            systemTime = ReadSystemTime(recordingFile);
            times{i} = systemTime;
        else
            camera = fread(recordingFile,1,'uint16=>double');
            systemTime = 0;
            error('Must determine framesize and position for current header version');
        end
    end    
    fclose(recordingFile);
    times = cell2mat(times);
end