% Estimate the drone's velocity at t = 5 s by differentiating the kernel
clear; clc;

% GPS data
t_gps = [0 1 2 3 4 5 6 7 8 9 10]';
x_gps = [3.6274 4.7839 12.2002 15.6936 21.4540 23.2871 28.9799 33.1312 39.0343 39.6250 40.1570]';
y_gps = [1.454 1.858 3.872 7.444 10.397 14.350 15.266 18.313 19.616 20.102 24.915]';
z_gps = [11.907 14.9641 14.1788 16.9027 19.2841 16.8510 27.8011 28.4035 30.1432 39.9430 41.9723]';

% Parameters
h = 1;      
t = 5;    

% Velocity from the kernel derivative:
% v_component = -sum[ g'_h(t - t_i) * position_i ]

vx = 0; vy = 0; vz = 0;

for i = 1:length(t_gps)
    tau = t - t_gps(i);    % time offset
    weight = bspline_kernel_derivative_h(tau, h);
    
    % -g'_h * f
    vx = vx - weight * x_gps(i);
    vy = vy - weight * y_gps(i);
    vz = vz - weight * z_gps(i);
end

speed = sqrt(vx^2 + vy^2 + vz^2);

fprintf('vx = %.4f m/s\n', vx);
fprintf('vy = %.4f m/s\n', vy);
fprintf('vz = %.4f m/s\n', vz);
fprintf('speed = %.4f m/s\n', speed);
