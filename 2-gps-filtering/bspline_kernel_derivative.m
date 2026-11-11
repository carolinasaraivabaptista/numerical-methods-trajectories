function val = bspline_kernel_derivative(x)
% Derivative g'(x) of the cubic B-spline kernel
    
    val = zeros(size(x));
    
    mask_pos = x > 0;
    x_pos = x(mask_pos);
    
    % Positive points
    if any(mask_pos)  
        mask1_pos = (x_pos < 1);  
        
        if any(mask1_pos)
            x_vals = x_pos(mask1_pos);
            deriv_case1 = (1/6) * (-12*x_vals + 9*x_vals.^2);
            val(mask_pos & (abs(x) < 1)) = deriv_case1;
        end
       
        mask2_pos = (x_pos >= 1) & (x_pos < 2);
        
        if any(mask2_pos)
            x_vals = x_pos(mask2_pos);
            deriv_case2 = -(1/2) * (2 - x_vals).^2;
            val(mask_pos & (abs(x) >= 1) & (abs(x) < 2)) = deriv_case2;
        end
    end
    
    % Negative points: g is even, so g' is odd: g'(-x) = -g'(x)
    mask_neg = x < 0;
    if any(mask_neg)
        val(mask_neg) = -bspline_kernel_derivative(-x(mask_neg));
    end
    
end
