% Second derivative x''(5) with the 5-point central finite difference
clear; clc;

% GPS data
t_gps = [0 1 2 3 4 5 6 7 8 9 10]';
x_gps = [3.6274 4.7839 12.2002 15.6936 21.4540 23.2871 28.9799 33.1312 39.0343 39.6250 40.1570]';

% Parameters
t = 5; 
h = 1;  % step
idx = find(t_gps == t);

% The 5 samples around t
x_minus2h = x_gps(idx - 2);
x_minus_h = x_gps(idx - 1);
x_center  = x_gps(idx);
x_plus_h  = x_gps(idx + 1);
x_plus2h  = x_gps(idx + 2);

% Stencil [-1, 16, -30, 16, -1] / (12 h^2)
numerator = -x_minus2h + 16*x_minus_h - 30*x_center + 16*x_plus_h - x_plus2h;
denominator = 12 * h^2;
x_second_deriv = numerator / denominator;

fprintf('\nx''''(5) = %.4f / %d = %.3f m/s^2\n', numerator, denominator, x_second_deriv);
