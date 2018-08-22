%  Create point cloud from raw frames
%  This code is derived from code in librealsense from intel on GitHub
function [color_pixel] = DepthPointToColorPixel(f, depth_point)
    f.depth = single(f.depth); 

    f.depth = permute(f.depth,[2,1,3]);
    f.color = permute(f.color,[2,1,3]);
 
    color_point = rs_transform_point_to_point_Mex(depth_point', struct(f.depth_to_color_extrinsics));   
    color_pixel = rs_project_point_to_pixel_Mex(color_point, struct(f.color_intrin) );  
    
    color_pixel = round(color_pixel)+1;
    color_pixel = color_pixel';
end


