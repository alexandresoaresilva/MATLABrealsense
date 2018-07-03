clc
addpath('robotLogFunctions');

%filePath = '..\2017.10.18 21.02.05 CDT.bin' ;
%filePath = '..\2017.10.18 21.01.33 CDT.bin' ;
filePath = 'C:\Users\Robert\Desktop\2017.08.05 23.43.26 CDT.bin' ;

targetCameraIdx = 1;


circles = [ 
    [136 490]
    [136 420]
    [136 350]
    [136 280]
    [136 208]
    [136 136]
    [203 490]
    [203 420]
    [203 350]
    [203 280]
    [203 208]
    [203 136]
    [274 490]
    [274 420]
    [274 350]
    [274 280]
    [274 208]
    [274 136]
    [344 490]
    [344 420]
    [344 350]
    [344 280]
    [344 208]
    [344 136]    
    ];

fileInfo = dir(filePath);
fileSize = fileInfo.bytes;

file = fopen(filePath);
[headerVersion,~] = ReadHeader(file);

numelFramesInFilePerCamera = floor(fileSize/frameSize(headerVersion)/3);

clf
hold on
radius = 5;
for j = 1:size(circles,1)
    rec = [ circles(j,1)- radius,  circles(j,2)- radius, radius*2, radius*2]; 
    rectangle('Position',rec,'Curvature',[1,1]);
end

    
for frameIdx = 1:numelFramesInFilePerCamera
    clf
    hold on    
    
    frame = ReadFrame(file, headerVersion, frameIdx, targetCameraIdx);
    imagesc(frame.color); axis equal; axis tight;
    imwrite(frame.color, strcat('scan', num2str(frameIdx), '.png'));
    drawnow

end




fclose(file);



