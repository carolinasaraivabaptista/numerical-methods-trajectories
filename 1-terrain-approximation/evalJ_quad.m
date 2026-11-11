function J = evalJ_quad(a,R1,R2,XMAX,YMAX)
    [phi_handles, ~] = basis3(XMAX,YMAX);
    p_handle = @(x,y) zeros(size(x));
    for k=1:length(a)
        pk = phi_handles{k};
        p_handle = @(x,y) p_handle(x,y) + a(k).*pk(x./XMAX,y./YMAX);
    end
    xi = [-0.9324695142031521, -0.6612093864662645, -0.2386191860831969, ...
           0.2386191860831969,  0.6612093864662645,  0.9324695142031521];
    wi = [0.1713244923791704, 0.3607615730481386, 0.4679139345726910, ...
          0.4679139345726910, 0.3607615730481386, 0.1713244923791704];
    function I = quad2D_local(fun, xa, xb, ya, yb)
        hx = (xb - xa)/2; mx = (xb + xa)/2;
        hy = (yb - ya)/2; my = (yb + ya)/2;
        I = 0;
        for ii=1:length(xi)
            x = mx + hx * xi(ii);
            for jj=1:length(xi)
                y = my + hy * xi(jj);
                I = I + wi(ii)*wi(jj)*fun(x,y);
            end
        end
        I = I * hx * hy;
    end
    I1 = quad2D_local(@(x,y) (zfun(x,y)+10 - p_handle(x,y)).^2, R1(1), R1(2), R1(3), R1(4));
    I2 = quad2D_local(@(x,y) wfun(x).*(zfun(x,y) + x - p_handle(x,y)).^2, R2(1), R2(2), R2(3), R2(4));
    J = I1 + I2;
end
