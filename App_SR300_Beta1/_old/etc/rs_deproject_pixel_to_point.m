%  Derived from intel's librealsense on GitHub
function [point, xyd] = rs_deproject_pixel_to_point(intrinsics, depth)
    if intrinsics.model == 1 % Cannot deproject from a forward-distorted image (1 = MODIFIED BROWN CONRADY)
        return
    end
    
    [x,y] = meshgrid((1:size(depth,2))-1, (1:size(depth,1))-1 );
        
    x = (x - intrinsics.ppx) ./ intrinsics.fx;
    y = (y - intrinsics.ppy) ./ intrinsics.fy;
    if intrinsics.model == 2 % 2 = INVERSE BROWN CONRADY
        r2  = x.*x + y.*y;
        f = 1 + intrinsics.coeffs(1).*r2 + intrinsics.coeffs(2).*r2.*r2 + intrinsics.coeffs(5).*r2.*r2.*r2;
        ux = x.*f + 2.*intrinsics.coeffs(3).*x.*y + intrinsics.coeffs(4).*(r2 + 2.*x.*x);
        uy = y.*f + 2.*intrinsics.coeffs(4).*x.*y + intrinsics.coeffs(3).*(r2 + 2.*y.*y);
        x = ux;
        y = uy;
    end
    point = [depth(:).*x(:), depth(:).*y(:), depth(:)];
end