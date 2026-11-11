function [A,b,phi_names,phi_handles] = assembleAB_quad(R1,R2,XMAX,YMAX)
    [phi_handles, phi_names] = basis3(XMAX,YMAX);
    n = numel(phi_handles);
    A = zeros(n,n);
    b = zeros(n,1);
    
    % 6-point Gauss-Legendre nodes and weights
    xi = [-0.9324695142031521, -0.6612093864662645, -0.2386191860831969, ...
           0.2386191860831969,  0.6612093864662645,  0.9324695142031521];
    wi = [0.1713244923791704, 0.3607615730481386, 0.4679139345726910, ...
          0.4679139345726910, 0.3607615730481386, 0.1713244923791704];

    function I = quad2D(fun, xa, xb, ya, yb)
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

    x1_lo = R1(1); x1_hi = R1(2); y1_lo = R1(3); y1_hi = R1(4);
    x2_lo = R2(1); x2_hi = R2(2); y2_lo = R2(3); y2_hi = R2(4);

    for i=1:n
        for j=i:n
            fR1 = @(x,y) phi_handles{i}(x./XMAX, y./YMAX) .* phi_handles{j}(x./XMAX, y./YMAX);
            I1 = quad2D(fR1, x1_lo, x1_hi, y1_lo, y1_hi);
            fR2 = @(x,y) wfun(x) .* phi_handles{i}(x./XMAX, y./YMAX) .* phi_handles{j}(x./XMAX, y./YMAX);
            I2 = quad2D(fR2, x2_lo, x2_hi, y2_lo, y2_hi);
            A(i,j) = I1 + I2;
            A(j,i) = A(i,j);
        end
        f1b = @(x,y) phi_handles{i}(x./XMAX, y./YMAX) .* ( zfun(x,y) + 10 );
        b1 = quad2D(f1b, x1_lo, x1_hi, y1_lo, y1_hi);
        f2b = @(x,y) wfun(x) .* phi_handles{i}(x./XMAX, y./YMAX) .* ( zfun(x,y) + x );
        b2 = quad2D(f2b, x2_lo, x2_hi, y2_lo, y2_hi);
        b(i) = b1 + b2;
    end
end
