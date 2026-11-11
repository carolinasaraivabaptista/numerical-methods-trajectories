function val = bspline_kernel(x)
% Cubic B-spline smoothing kernel g(x)
%   Input:  x   - scalar or vector
%   Output: val - kernel values

    val = zeros(size(x));
    x_abs = abs(x);
    
    % Case 1: |x| < 1
    mask1 = x_abs < 1;
    val(mask1) = (1/6) * (4 - 6*x_abs(mask1).^2 + 3*x_abs(mask1).^3);
    
    % Case 2: 1 <= |x| < 2
    mask2 = (x_abs >= 1) & (x_abs < 2);
    val(mask2) = (1/6) * (2 - x_abs(mask2)).^3;
    
    % Case 3: |x| >= 2 stays zero
end
