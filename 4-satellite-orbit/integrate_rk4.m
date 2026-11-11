function sol = integrate_rk4(y0, t, h, mu)
% Integrate satellite_system with RK4 over the time grid t.
% Returns a 4 x length(t) matrix with the state at each time.
    sol = zeros(4, length(t));
    sol(:, 1) = y0;
    for i = 1:(length(t) - 1)
        sol(:, i + 1) = rk4_step(t(i), sol(:, i), h, mu);
    end
end
