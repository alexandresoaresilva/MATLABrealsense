%  Read camera intrinsics from file
function [intrinsics] = ReadIntrinsics(file)
    %  Read values from file
    width = fread(file,1,'int32=>single');
    height = fread(file,1,'int32=>single');
    ppx = fread(file,1,'single=>single');
    ppy = fread(file,1,'single=>single');
    fx = fread(file,1,'single=>single');
    fy = fread(file,1,'single=>single');
    model = fread(file,1,'int32=>single');
    coeffs = fread(file,5,'single=>single')';

    
    %  Create struct from values
    intrinsics = struct('width',width,'height',height,'ppx',ppx,'ppy',ppy,'fx',fx,'fy',fy,'model',model,'coeffs',coeffs);
end