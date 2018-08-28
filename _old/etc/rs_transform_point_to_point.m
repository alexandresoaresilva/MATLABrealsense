%  Derived from intel's librealsense on GitHub
function [to_point] = rs_transform_point_to_point(extrinsics, from_point)
    r = reshape(extrinsics.rotation, [3,3])';
    to_point = from_point*r+ones(size(from_point,1),1)*extrinsics.translation;
end