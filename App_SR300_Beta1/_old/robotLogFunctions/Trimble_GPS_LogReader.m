javaaddpath([pwd filesep, 'Trimble.jar']);
import trimble.*


fileInfo = {'504', 'E:\Recordings\2017.6.28\504\GPS LogWed Jun 28 04.51.26 CDT 2017.bin'};
fileInfo = {'507', 'E:\Recordings\2017.6.28\507\GPS LogWed Jun 28 04.24.39 CDT 2017.bin'};
fileInfo = {'510', 'E:\Recordings\2017.6.28\510\GPS LogWed Jun 28 04.46.24 CDT 2017.bin'};
fileInfo = {'511', 'E:\Recordings\2017.6.28\511\GPS LogWed Jun 28 04.28.39 CDT 2017.bin'};
fileInfo = {'603', 'E:\Recordings\2017.6.28\603\GPS LogWed Jun 28 05.01.47 CDT 2017.bin'};
fileInfo = {'605', 'E:\Recordings\2017.6.28\605\GPS LogWed Jun 28 05.05.09 CDT 2017.bin'};
fileInfo = {'613', 'E:\Recordings\2017.6.28\613\GPS LogWed Jun 28 05.08.56 CDT 2017.bin'};
fileInfo = {'614', 'E:\Recordings\2017.6.28\614\GPS LogWed Jun 28 05.40.14 CDT 2017.bin'};

clc
disp(fileInfo{1})
file = java.io.File(fileInfo{2});
fis = java.io.FileInputStream(file);
gpsLog = TrimbleLogReader.readLog(fis);
for i = (1:gpsLog.size)-1
    report = gpsLog.get(i);
    switch char(report.getClass().toString)
        case 'class trimble.SuperPacketOutputReport'
%             fprintf('latitude, longitude, altitudeMillimeters = %f, %f, %i\n', ...
            fprintf('%f,%f,%i ', ...
                report.longitude, report.latitude, report.altitudeMillimeters);
    end
end

