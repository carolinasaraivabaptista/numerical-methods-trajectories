% Reconstruct the drone's motion by smoothing noisy GPS samples
% with the cubic B-spline kernel g_eps (eps = 1)

t = 0:10;
x = [3.6274 4.7839 12.2002 15.6936 21.4540 23.2871 28.9799 33.1312 39.0343 39.6250 40.1570];
y = [1.454 1.858 3.872 7.444 10.397 14.350 15.266 18.313 19.616 20.102 24.915];
z = [11.907 14.9641 14.1788 16.9027 19.2841 16.8510 27.8011 28.4035 30.1432 39.9430 41.9723];

% eps = 1, integer sample points (one sample per second)
x_kernel = -2:2;
w = bspline_kernel(x_kernel);
w = w / sum(w);     % discrete normalisation (weights sum to 1)

% Discrete convolution
x_smooth = conv(x, w, 'same');
y_smooth = conv(y, w, 'same');
z_smooth = conv(z, w, 'same');

% Comparison table
T = table(t', x_smooth', y_smooth', z_smooth', ...
    'VariableNames', {'t_s', 'x_smoothed', 'y_smoothed', 'z_smoothed'});

disp('Smoothed values:')
disp(T)

% Plots
figure;
subplot(3,1,1);
plot(t, x, 'o-', t, x_smooth, '-', 'LineWidth', 1.5);
title('x(t)'); legend('GPS', 'Smoothed');

subplot(3,1,2);
plot(t, y, 'o-', t, y_smooth, '-', 'LineWidth', 1.5);
title('y(t)'); legend('GPS', 'Smoothed');

subplot(3,1,3);
plot(t, z, 'o-', t, z_smooth, '-', 'LineWidth', 1.5);
title('z(t)'); legend('GPS', 'Smoothed');
xlabel('t (s)');

saveas(gcf, 'smooth_path.png');
