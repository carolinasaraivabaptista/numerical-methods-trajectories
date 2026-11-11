function main_drone_improved()
% MAIN_DRONE_IMPROVED  Weighted least-squares fit of a cubic surface p(x,y)
% to the flight-altitude target, assembled with Gauss-Legendre quadrature.
% Point constraints are imposed with Lagrange multipliers.
% Run: main_drone_improved

    close all; clearvars; clc;

    XMAX = 15; YMAX = 10;
    R1 = [12 15 7 10];
    R2 = [0 12 0 7];

    [A,b,phi_names,phi_handles] = assembleAB_quad(R1,R2,XMAX,YMAX);

    n = length(b);

    % Point constraints at (0,0) and (12,7)
    s0 = 0; t0 = 0;
    s1 = 12 / XMAX; t1 = 7 / YMAX;
    C = zeros(2,n);
    for j=1:n
        C(1,j) = phi_handles{j}(s0,t0);
        C(2,j) = phi_handles{j}(s1,t1);
    end
    d = [zfun(0,0); zfun(12,7) + 10];

    % KKT system for the constrained least-squares problem
    K = [A, C'; C, zeros(2,2)];
    rhs = [b; d];

    sol = K \ rhs;
    a = sol(1:n);
    lambda = sol(n+1:end);

    Jval = evalJ_quad(a,R1,R2,XMAX,YMAX);

    phi_names_str = string(phi_names);
    T = table((1:n)', phi_names_str, a, 'VariableNames', {'Index','Basis','Coefficient'});
    disp('Coefficients of p (monomial basis in normalised s,t):');
    disp(T);
    fprintf('Value of the functional J(p) = %.6g\n', Jval);

    p_fun = @(x,y) eval_p_from_coeffs(a, x, y, XMAX, YMAX, phi_handles);
    plot_overlaid_surfaces(p_fun);
    
end
