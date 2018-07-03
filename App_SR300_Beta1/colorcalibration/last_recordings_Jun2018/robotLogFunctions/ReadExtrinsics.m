%  Read camera extrinsics from file
function [extrinsics] = ReadExtrinsics(file)
    %  Read values from file
    rotation = fread(file,9,'single=>single')';
    translation = fread(file,3,'single=>single')';

    %  Create struct from values
    extrinsics = struct('rotation',rotation,'translation',translation);
end