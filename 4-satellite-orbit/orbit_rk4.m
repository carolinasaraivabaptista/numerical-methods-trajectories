% Arenstorf periodic orbit integrated with RK4 over 3 periods
clear; close all; clc;

% Problem parameters
mu = 0.012277471;           % Moon / (Earth + Moon) mass ratio
T = 17.065216560158;        % orbit period
t_final = 3 * T;            % 3 full periods

% Initial state [x, y, vx, vy]
y0_vec = [0.994; 0; 0; -2.001585106379];

% Method parameters
h = 0.0001;                 % step size
t = 0:h:t_final;

sol = integrate_rk4(y0_vec, t, h, mu);
x = sol(1, :);
y = sol(2, :);

figure('Position', [100 100 1000 800]);

% Plot 1: full orbit (3 periods)
subplot(2, 2, 1);
plot(x, y, 'b-', 'LineWidth', 1.5);
hold on;
plot(x(1), y(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);      % start
plot(x(end), y(end), 'r*', 'MarkerSize', 15, 'LineWidth', 2);  % end
plot(1 - mu, 0, 'k*', 'MarkerSize', 12);                       % Moon
plot(-mu, 0, 'ko', 'MarkerSize', 8);                           % Earth
grid on;
xlabel('x'); ylabel('y');
title('Satellite orbit - 3 periods');
legend('Trajectory', 'Start', 'End', 'Moon', 'Earth');
axis equal;

% Plot 2: one period
subplot(2, 2, 2);
idx_1period = find(t <= T);
plot(x(idx_1period), y(idx_1period), 'r-', 'LineWidth', 2);
hold on;
plot(x(1), y(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(1 - mu, 0, 'k*', 'MarkerSize', 12);
plot(-mu, 0, 'ko', 'MarkerSize', 8);
grid on;
xlabel('x'); ylabel('y');
title(['One period (T = ' num2str(T, '%.3f') ')']);
legend('Trajectory', 'Start', 'Moon', 'Earth');
axis equal;

% Plot 3: position components over time
subplot(2, 2, 3);
plot(t, x, 'b-', 'DisplayName', 'x(t)');
hold on;
plot(t, y, 'r-', 'DisplayName', 'y(t)');
grid on;
xlabel('Time'); ylabel('Position');
title('Position components over time');
legend('show');
