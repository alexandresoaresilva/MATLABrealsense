function recordings = locateAllRecordings(base)

    binFiles = dir([base, '**/*.bin']);

    keepers = cellfun(@isempty, strfind(cat(1,{binFiles.name}), 'GPS'));
    binFiles = binFiles(keepers);

    recordingStruct = @(a) struct(  'dateNum', cell(a,1), ...
                                    'fileName', []);

    recordings = [];
    recordings.irrigation.FM2322 = recordingStruct(0);
    recordings.irrigation.ST4747 = recordingStruct(0);
    recordings.rain.FM2322 = recordingStruct(0);
    recordings.rain.ST4747 = recordingStruct(0);
    recordings.misc = recordingStruct(0);

    for i = 1:numel(binFiles)    
        r = recordingStruct(1);
        try
            rF = binFiles(i);
            temp = strrep(rF.folder, base, '');
            ps = strsplit(temp, filesep);
            temp = ps{1};
            ps = strsplit(temp, ' ' );
            dateText = ps{1};
            r.dateNum = datetime(dateText, 'InputFormat', 'yyyy.MM.dd');   
        catch
            continue;
        end

        files = dir(rF.folder);
        files(1:2) = [];
        names = cat(1,{files.name});

        fileGPS_Index = cellfun(@(a) ~isempty(a), strfind(names, 'GPS '));
        names(fileGPS_Index) = [];
        fileFramesIndex = cellfun(@(a) ~isempty(a), strfind(names, '.bin'));
        fileNameFrames = names{fileFramesIndex};

        r.fileName = [rF.folder, filesep, fileNameFrames];

        if strfind(rF.folder, 'irrigation')
            if strfind(rF.folder, 'FM2322')
                recordings.irrigation.FM2322(end+1) = r;
            elseif strfind(rF.folder, 'ST4747')
                recordings.irrigation.ST4747(end+1) = r;
            else
                recordings.irrigation(end+1) = r;
            end
        elseif strfind(rF.folder, 'rain')
            if strfind(rF.folder, 'FM2322')
                recordings.rain.FM2322(end+1) = r;
            elseif strfind(rF.folder, 'ST4747')
                recordings.rain.ST4747(end+1) = r;
            else
                recordings.rain(end+1) = r;
            end
        else
            recordings.misc(end+1) = r;
        end  
    end
end










