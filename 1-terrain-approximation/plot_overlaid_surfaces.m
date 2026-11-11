function plot_overlaid_surfaces(p_fun)
    XMAX = 15; YMAX = 10;
    nx = 80; ny = 60;
    xs = linspace(0,XMAX,nx);
    ys = linspace(0,YMAX,ny);
    [X,Y] = meshgrid(xs,ys);
    Z = zfun(X,Y);
    P = p_fun(X,Y);
    figure;
    hold on;
    surf(X,Y,Z,'FaceAlpha',0.6,'EdgeColor','none');
    surf(X,Y,P,'FaceAlpha',0.6,'EdgeColor','none');
    xlabel('x'); ylabel('y'); zlabel('Height (m)');
    title('Terrain z(x,y) and flight surface p(x,y)');
    legend('z(x,y)','p(x,y)','Location','northoutside');
    axis auto; view(-45,30); grid on;
    hold off;
    saveas(gcf, 'terrain_and_flight_surface.png');
end
