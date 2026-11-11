function y_next = rk4_step(t, y, h, mu)
% One classic 4th-order Runge-Kutta step for satellite_system
    k1 = satellite_system(t,       y,            mu);
    k2 = satellite_system(t + h/2, y + (h/2)*k1, mu);
    k3 = satellite_system(t + h/2, y + (h/2)*k2, mu);
    k4 = satellite_system(t + h,   y + h*k3,     mu);
    y_next = y + (h/6) * (k1 + 2*k2 + 2*k3 + k4);
end
