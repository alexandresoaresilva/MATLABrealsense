%  Create point cloud from raw frames
%  This code is derived from code in librealsense from intel on GitHub
function [ptc, color_pixel] = CreatePointCloudMex(f, xy, depth)
    f.depth = single(f.depth); 

    f.depth = permute(f.depth,[2,1,3]);
    f.color = permute(f.color,[2,1,3]);
    
%     f.depth = imrotate(f.depth, 90);
%     f.color = imrotate(f.color, 90);

    if exist('xy', 'var') && ~exist('depth', 'var')
        if size(xy,2) ~= 2
            error('size(xy,2) must equal 2');
        end     
        xy = flip(xy,2);
        depth_in_meters = f.depth(sub2ind(size(f.depth), xy(:,1), xy(:,2)))* f.scale;
    elseif exist('xy', 'var') && exist('depth', 'var')
        if numel(depth) ~= size(xy,1)
            error('depth elements must match size(xy,1)')
        end
        if size(xy,2) ~= 2
            error('size(xy,2) must equal 2');
        end
        xy = flip(xy,2);
        depth_in_meters = single(depth) * f.scale;
    else
        [y,x] = meshgrid((1:size(f.depth,2)), (1:size(f.depth,1)) );
        xy = [x(:),y(:)];
        depth_in_meters = f.depth * f.scale;
        toRemove = depth_in_meters==0;
        toRemove = imdilate(toRemove, strel('square',3));
        depth_in_meters(toRemove) = [];
        xy(toRemove,:) = [];
    end
    
    depth_point = rs_deproject_pixel_to_point_Mex(xy'-1, struct(f.depth_intrin), depth_in_meters);
    color_point = rs_transform_point_to_point_Mex(depth_point, struct(f.depth_to_color_extrinsics));   
    color_pixel = rs_project_point_to_pixel_Mex(color_point, struct(f.color_intrin) )';  
    depth_point = depth_point';
    
    color_pixel = round(color_pixel)+1;
    toRemove = color_pixel(:,1) < 1 | color_pixel(:,2) < 1 | color_pixel(:,1) > f.color_intrin.width | color_pixel(:,2) > f.color_intrin.height;
    depth_point(toRemove,:) = [];
    color_pixel(toRemove,:) = [];
    
    coords = depth_point;
    idx = sub2ind([size(f.color,1),size(f.color,2)], color_pixel(:,1), color_pixel(:,2));
    color = f.color;
    color = reshape(color, size(f.color,1)*size(f.color,2),3);
    color = color(idx,:);
    
    ptc = pointCloud(coords, 'Color', color, 'Normal', coords);
end


