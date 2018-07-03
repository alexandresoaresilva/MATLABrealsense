function [frame] = ReadFrame(recordingFile, headerVersion, frameIdx, cameraIdx)
    
    %  Read frame info
    if headerVersion >= 2
        numelCameras = 3;
        framePosition = 4+frameSize(headerVersion)*(frameIdx*numelCameras+cameraIdx);
        fseek(recordingFile, framePosition, 'bof');
        camera = fread(recordingFile,1,'uint16=>double');
        systemTime = ReadSystemTime(recordingFile);
    else
        camera = fread(recordingFile,1,'uint16=>double');
        systemTime = 0;
        error('Must determine framesize and position for current header version');
    end
    
    try
        
        scale = fread(recordingFile,1,'single=>double');
    %     scale = (1/32) * 0.001;  %  The DLL needs to be updated to record this to the file, use default value for now (1/32 of a mm)
        color_intrin = ReadIntrinsics(recordingFile);
        depth_intrin = ReadIntrinsics(recordingFile);
        depth_to_color_extrinsics = ReadExtrinsics(recordingFile);

        %  Read color frame
        color_bytes = fread(recordingFile,color_intrin.width * color_intrin.height * 3,'uint8=>uint8');
        %  Convert uint8 color values into RGB cube for MATLAB to plot

        color = reshape(color_bytes, [3, color_intrin.width, color_intrin.height] );
        color = permute(color, [3,2,1]);

        %  Read depth frame
        depth_pixels = fread(recordingFile,depth_intrin.width * depth_intrin.height,'uint16=>uint16');
        %  Convert uint16 stream into a frame
        depth = uint16(zeros([depth_intrin.height depth_intrin.width]));
        for m = 1:depth_intrin.height
            depth(m,:) = depth_pixels((((m-1)*depth_intrin.width)+1):(m*depth_intrin.width));
        end

        switch(headerVersion)
            case 1 % Initial version, no IMU data
                IMU = 0;
            case 2 % Added IMU data
                IMU = fread(recordingFile, 9, 'int16=>double');
                % Order of data in array is AccX, AccY, AccZ, GyrX, GyrY, GyrZ,
                % MagX, MagY, MagZ
            otherwise
                disp 'Invalid Header Version'
        end

        frame.camera = camera;
        frame.scale = scale;
        frame.color_intrin = color_intrin;
        frame.depth_intrin = depth_intrin;
        frame.depth_to_color_extrinsics = depth_to_color_extrinsics;
        frame.color = color;
        frame.depth = depth;
        frame.IMU = IMU;
        frame.systemTime = systemTime;
    catch e
        warning('could not read frame');
        rethrow(e);
        frame = [];
        return;
    end
end