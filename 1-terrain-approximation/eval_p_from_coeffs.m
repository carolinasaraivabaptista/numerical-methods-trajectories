function val = eval_p_from_coeffs(a, x, y, XMAX, YMAX, phi_handles)
    s = x ./ XMAX;
    t = y ./ YMAX;
    val = zeros(size(x));
    for k=1:length(a)
        val = val + a(k) .* phi_handles{k}(s,t);
    end
end
