function val = zfun(x,y)
val = 0.5.*x + 0.3.*y + 2.*sin(x./5) + 3.*cos(y./2) ...
+ 0.35.*sin(12.*x./5).*cos(8.*y) + 0.1.*sin(10.*x).*sin(40.*y);
end