clear all
clc
addpath('robotLogFunctions\')
addpath('pointCloud\')

binFileName = 'D:\Users\alexa\Documents\GitHub\MATLABrealsense\App_SR300_Beta1\colorcalibration\last_recordings_Jun2018\2018.06.21 21.59.06 CDT.bin';
targetCameraIdx = 0; % should be within the set [0:2]

fileInfo = dir(binFileName);
fileSize = fileInfo.bytes;

file = fopen(binFileName);

[headerVersion,~] = ReadHeader(file);
numelFramesInFilePerCamera = floor(fileSize/frameSize(headerVersion)/3);
for fIdx = (1:numelFramesInFilePerCamera)
    frame = ReadFrame(file,headerVersion, fIdx, targetCameraIdx);
    imagesc(frame.color); axis equal; axis tight; drawnow
%     ptc = denoiseAndTrimPC(CreatePointCloudMex(frame), targetCameraIdx);      
%     pcshow(ptc); drawnow
end

fclose(file);













