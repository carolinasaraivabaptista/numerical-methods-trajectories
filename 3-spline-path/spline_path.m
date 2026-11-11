% Smooth drone path through 10 waypoints with clamped cubic splines.
% Builds the tridiagonal system for the second derivatives, solves it,
% writes each spline as a piecewise LaTeX expression and plots the path.

x = [0 12 28 45 62 78 88 95 110 125];   % waypoints, x coordinate
y = [0 7 18 25 22 15 8 3 7 12];         % waypoints, y coordinate
t = [0 3 7 11 14 18 22 25 30 36];       % time at each waypoint
h = diff(t);                            % interval lengths
N = length(x);                          % number of waypoints

% Tridiagonal N x N system for the second derivatives (zero end velocities)
A = zeros(N, N);
A(1,1) = h(1)/3;
A(1,2) = h(1)/6;
for k = 2:N-1
    A(k, k-1) = h(k-1)/6;
    A(k, k)   = (h(k-1) + h(k))/3; 
    A(k, k+1) = h(k)/6;
end
A(N, N-1) = h(end)/6;
A(N, N)   = h(end)/3;

coef_x = spline_coefficients(x, t, h, A);
coef_y = spline_coefficients(y, t, h, A);

write_latex(coef_x, t, 's_x', 'splines_x.tex');
write_latex(coef_y, t, 's_y', 'splines_y.tex');

% Evaluate each piece on a fine grid so the path looks continuous
n = N - 1;
x_vals = [];
y_vals = [];
for i = 1:n
    ti = t(i);
    tt = linspace(ti, t(i+1), 100);
    f_x = @(s) coef_x(i,1) + coef_x(i,2).*(s-ti) + coef_x(i,3).*(s-ti).^2 + coef_x(i,4).*(s-ti).^3;
    f_y = @(s) coef_y(i,1) + coef_y(i,2).*(s-ti) + coef_y(i,3).*(s-ti).^2 + coef_y(i,4).*(s-ti).^3;
    x_vals = [x_vals, f_x(tt)];
    y_vals = [y_vals, f_y(tt)];
end

% Plot the path
figure;
plot(x_vals, y_vals, 'b-', 'LineWidth', 2); hold on;
plot(x, y, 'ko', 'MarkerSize', 5);
plot(x_vals(1), y_vals(1), 'go', 'MarkerFaceColor','g'); 
plot(x_vals(end), y_vals(end), 'ro', 'MarkerFaceColor','r'); 
grid on;
xlabel('x');
ylabel('y');
title('Drone path (cubic spline)');
legend('Path', 'Waypoints', 'Start', 'End', 'Location', 'best');
axis equal;


function coef = spline_coefficients(v, t, h, A)
% Coefficients [a b c d] of each piece a + b(t-t_k) + c(t-t_k)^2 + d(t-t_k)^3
    N = length(v);

    % Right-hand side of the system
    b = zeros(N,1);
    b(1) = (v(2)-v(1))/h(1);
    for k = 2:N-1
        b(k) = (v(k+1)-v(k))/h(k) - (v(k)-v(k-1))/h(k-1);
    end
    b(N) = -(v(N)-v(N-1))/h(end);

    s2 = A\b;   % second derivatives at the waypoints

    coef = zeros(N-1,4);
    for k = 1:N-1
        s1 = (v(k+1)-v(k))/h(k) - h(k)/6 * (2*s2(k) + s2(k+1));   % first derivative
        coef(k,:) = [v(k), s1, s2(k)/2, (s2(k+1)-s2(k))/(6*h(k))];
    end
end

function write_latex(coef, t, name, filename)
% Write the spline as a piecewise function in LaTeX
    n = size(coef,1);
    fmtNum = @(v) sprintf('%.8g', v);   % 8 significant digits

    fid = fopen(filename,'w');
    if fid > 0
        fprintf(fid,'\\[\n');
        fprintf(fid,'%s(t) = \\begin{cases}\n', name);
        for i = 1:n
            ti = t(i);
            expr = sprintf('%s + %s\\,(t - %g) + %s\\,(t - %g)^2 + %s\\,(t - %g)^3', ...
                fmtNum(coef(i,1)), fmtNum(coef(i,2)), ti, fmtNum(coef(i,3)), ti, fmtNum(coef(i,4)), ti);
            if i < n
                fprintf(fid,'\t%s, & t \\in [%g, %g] \\\\[6pt]\n', expr, ti, t(i+1));
            else
                fprintf(fid,'\t%s, & t \\in [%g, %g]\n', expr, ti, t(i+1));   % last piece, no line break
            end
        end
        fprintf(fid,'\\end{cases}\n');
        fprintf(fid,'\\]\n');
        fclose(fid);
    end
end
