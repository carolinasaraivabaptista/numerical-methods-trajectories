function dydt = satellite_system(t, y, mu)
% Restricted three-body problem (Earth-Moon) in the rotating frame.
% State y = [x, y, vx, vy]
    x = y(1);
    y_pos = y(2);
    vx = y(3);
    vy = y(4);
    
    % Distances to the Earth (D1) and the Moon (D2), cubed
    D1 = ((x + mu)^2 + y_pos^2)^(3/2);
    D2 = ((x - (1 - mu))^2 + y_pos^2)^(3/2);
    
    % Acceleration
    ax = x + 2*vy - (1 - mu)*(x + mu)/D1 - mu*(x - (1 - mu))/D2;
    ay = y_pos - 2*vx - (1 - mu)*y_pos/D1 - mu*y_pos/D2;
    
    % First-order system
    dydt = [vx; vy; ax; ay];
end
