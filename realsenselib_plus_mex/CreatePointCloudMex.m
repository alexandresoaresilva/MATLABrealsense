%  Create point cloud from raw frames
%  This code is derived from code in librealsense from intel on GitHub
function [ptc] = CreatePointCloudMex(f)
       
    depth_in_meters = f.depth_image * f.scale;
    
    [y,x] = meshgrid((1:size(depth_in_meters,2))-1, (1:size(depth_in_meters,1))-1 );
    xy = [x(:),y(:)]';
    
    depth_in_meters = depth_in_meters(:);
        
    toRemove = depth_in_meters==0;
    depth_in_meters(toRemove) = [];
    xy(:, toRemove) = [];
    
    depth_point = rs_deproject_pixel_to_point_Mex(xy, struct(f.depth_intrin), depth_in_meters);
    color_point = rs_transform_point_to_point_Mex(depth_point, struct(f.depth_to_color_extrinsics));   
    color_pixel = rs_project_point_to_pixel_Mex(color_point, struct(f.color_intrin) )';
    depth_point = depth_point';
    
    color_pixel = round(color_pixel)+1;
    toRemove = color_pixel(:,1) < 1 | color_pixel(:,2) < 1 | color_pixel(:,1) > f.color_intrin.width | color_pixel(:,2) > f.color_intrin.height;
    depth_point(toRemove,:) = [];
    color_pixel(toRemove,:) = [];
    
    coords = depth_point;
    idx = sub2ind([size(f.color_image,1),size(f.color_image,2)], color_pixel(:,1), color_pixel(:,2));
    color = f.color_image;
    color = reshape(color, size(f.color_image,1)*size(f.color_image,2),3);
    color = color(idx,:);
    
    ptc = pointCloud(coords, 'Color', color, 'Normal', coords);

end


