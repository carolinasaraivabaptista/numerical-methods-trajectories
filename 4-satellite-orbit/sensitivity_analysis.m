% Sensitivity to initial conditions: perturb x0 by eps and track how far
% the perturbed orbit drifts from the original one (Lyapunov-style analysis)
clear; close all; clc;

mu = 0.012277471;
T = 17.065216560158;        % orbit period
h = 0.0001;                 % step size
t_final = 3 * T;            % 3 periods
t = 0:h:t_final;

eps_values = [1e-4, 1e-5, 1e-7, 1e-8];   % perturbation sizes

y0_vec = [0.994; 0; 0; -2.001585106379];
sol_original = integrate_rk4(y0_vec, t, h, mu);
x_orig = sol_original(1, :);
y_orig = sol_original(2, :);

for k = 1:length(eps_values)
    eps_k = eps_values(k);
   
    % Perturbed trajectory
    y0_pert = y0_vec + [eps_k; 0; 0; 0];
    sol_pert = integrate_rk4(y0_pert, t, h, mu);
    x_pert = sol_pert(1, :);
    y_pert = sol_pert(2, :);

    % Euclidean distance between the two trajectories over time
    distance = sqrt((x_orig - x_pert).^2 + (y_orig - y_pert).^2);
    
    figure('Position', [50 + k*60, 50 + k*60, 1200, 600]);
    sgtitle(sprintf('Sensitivity for \\epsilon = %.0e (3 periods)', eps_k), ...
            'FontSize', 16, 'FontWeight', 'bold');
            
    % Plot 1: both orbits
    subplot(1, 2, 1);
    plot(x_orig, y_orig, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Original orbit');
    hold on;
    plot(x_pert, y_pert, 'r--', 'DisplayName', 'Perturbed orbit');
    title('Original vs perturbed orbit');
    xlabel('x'); ylabel('y');
    legend('Location', 'northwest');
    axis equal; grid on;
    set(gca, 'FontSize', 12);
    
    % Plot 2: distance over time (log scale)
    subplot(1, 2, 2);
    semilogy(t, distance, 'k-', 'LineWidth', 1.5);
    title('Distance between trajectories');
    xlabel('Time'); ylabel('Euclidean distance (log scale)');
    grid on;
    set(gca, 'FontSize', 12);
end
