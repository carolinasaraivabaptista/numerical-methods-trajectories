function val = bspline_kernel_derivative_h(x, h)
% Derivative of the scaled kernel g_h(x) = g(x/h)/h
    val = (1/h^2) * bspline_kernel_derivative(x/h);
end
