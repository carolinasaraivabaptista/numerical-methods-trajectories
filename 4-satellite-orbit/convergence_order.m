% Empirical order of convergence of Euler, Heun (RK2) and RK4
% on the satellite problem, against a fine RK4 reference solution.

mu = 0.012277471;
y0_vec = [0.994; 0; 0; -2.001585106379];
t_final = 1.0;   % short interval to keep the error small

% Reference solution: RK4 with a very small step
h_ref = 1e-6; 
t_ref = 0:h_ref:t_final;
z_ref_T = get_final_state('RK4', y0_vec, t_ref, h_ref, mu);

h_values = [5e-5, 2.5e-5, 1.25e-5]; 
methods = {'Euler', 'RK2', 'RK4'};

for m = 1:length(methods)
    method_name = methods{m};
    fprintf('--- Order check for the %s method ---\n', method_name);
    
    errors = zeros(size(h_values));
    for j = 1:length(h_values)
        h = h_values(j);
        t = 0:h:t_final;
        z_final = get_final_state(method_name, y0_vec, t, h, mu);
        errors(j) = norm(z_final - z_ref_T);
    end
    
    % Halving h should divide the error by 2^p
    ratios = errors(1:end-1) ./ errors(2:end);
    orders = log2(ratios);
    
    fprintf('%-12s | %-12s | %-15s | %-20s | %-15s\n', ...
        'h', 'N_steps', 'Error (E)', 'Ratio (E_i/E_{i+1})', 'Estimated order');
    fprintf('%s\n', repmat('-', 1, 85));
    N_steps_list = round(t_final./h_values);
    fprintf('%-12.2e | %-12d | %-15.4e | %-20s | %-15s\n', ...
        h_values(1), N_steps_list(1), errors(1), '---', '---');
    for j = 1:length(orders)
        fprintf('%-12.2e | %-12d | %-15.4e | %-20.4f | %-15.4f\n', ...
            h_values(j+1), N_steps_list(j+1), errors(j+1), ratios(j), orders(j));
    end
    fprintf('\n');
end


function z_final = get_final_state(method, y0, t_vec, h, mu)
% Integrate with the chosen method and return the final state
    sol = zeros(4, length(t_vec));
    sol(:, 1) = y0;
    for i = 1:(length(t_vec) - 1)
        y_current = sol(:, i);
        switch method
            case 'Euler'
                k1 = satellite_system(0, y_current, mu);
                sol(:, i + 1) = y_current + h * k1;
            case 'RK2'
                k1 = satellite_system(0, y_current, mu);
                y_predictor = y_current + h * k1;
                k2 = satellite_system(0, y_predictor, mu);
                sol(:, i + 1) = y_current + (h/2) * (k1 + k2);
            case 'RK4'
                sol(:, i + 1) = rk4_step(0, y_current, h, mu);
        end
    end
    z_final = sol(:, end);
end
