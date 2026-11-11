function [phi, names] = basis3(XMAX,YMAX)
% Cubic monomial basis phi_k(s,t), with s = x/XMAX and t = y/YMAX
phi = cell(10,1);
names = cell(10,1);
phi{1} = @(s,t) ones(size(s)); names{1} = '1';
phi{2} = @(s,t) s; names{2} = 's';
phi{3} = @(s,t) t; names{3} = 't';
phi{4} = @(s,t) s.^2; names{4} = 's^2';
phi{5} = @(s,t) s.*t; names{5} = 's t';
phi{6} = @(s,t) t.^2; names{6} = 't^2';
phi{7} = @(s,t) s.^3; names{7} = 's^3';
phi{8} = @(s,t) s.^2.*t; names{8} = 's^2 t';
phi{9} = @(s,t) s.*t.^2; names{9} = 's t^2';
phi{10}= @(s,t) t.^3; names{10} = 't^3';

% Note: p(x,y) = sum_j a_j * phi_j(x/XMAX, y/YMAX)
end
