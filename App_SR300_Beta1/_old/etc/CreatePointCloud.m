%  Create point cloud from raw frames
%  This code is derived from code in librealsense from intel on GitHub
function [ptc] = CreatePointCloud(f)
    f.depth = double(f.depth);  % Convert depth to doubles
    
    % Remove edges in depth image due to glitches that occur on edges
    edges = edge(f.depth);
    f.depth(edges) = 0;
    
    % Scale depth value to meters
    depth_in_meters = f.depth * f.scale;
        
    [depth_point] = rs_deproject_pixel_to_point(f.depth_intrinsics, depth_in_meters);
    color_point = rs_transform_point_to_point(f.depth_to_color_extrinsics, depth_point);
    color_pixel = rs_project_point_to_pixel(f.color_intrinsics, color_point);
    
    color_pixel = round(color_pixel);
    toRemove = color_pixel(:,1) < 1 | color_pixel(:,2) < 1 | color_pixel(:,1) > f.color_intrinsics.width | color_pixel(:,2) > f.color_intrinsics.height;
    depth_point(toRemove,:) = [];
    color_pixel(toRemove,:) = [];
    
    coords = depth_point;
    idx = sub2ind([size(f.color,1),size(f.color,2)], color_pixel(:,2), color_pixel(:,1));
    color = reshape(f.color, size(f.color,1)*size(f.color,2),3);
    color = color(idx,:);
    
    ptc = pointCloud(coords, 'Color', color, 'Normal', coords);

end


















