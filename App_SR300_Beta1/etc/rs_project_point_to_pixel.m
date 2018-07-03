function [pixel] = rs_project_point_to_pixel(intrinsics, point)
    if intrinsics.model == 2  % Cannot project to an inverse-distorted image 2 = INVERSE BROWN CONRADY
        return
    end
    
    x = point(:,1) ./ point(:,3);
    y = point(:,2) ./ point(:,3);
    if intrinsics.model == 1 % 1 = MODIFIED BROWN CONRADY
        r2  = x.*x + y.*y;
        f = 1 + intrinsics.coeffs(1).*r2 + intrinsics.coeffs(2).*r2.*r2 + intrinsics.coeffs(5).*r2.*r2.*r2;
        x  = x .* f;
        y = y .* f;
        dx = x + 2.*intrinsics.coeffs(3).*x.*y + intrinsics.coeffs(4).*(r2 + 2.*x.*x);
        dy = y + 2.*intrinsics.coeffs(4).*x.*y + intrinsics.coeffs(3).*(r2 + 2.*y.*y);
        x = dx;
        y = dy;
    end
    pixel = [x.*intrinsics.fx+ intrinsics.ppx, y.*intrinsics.fy+intrinsics.ppy];
end