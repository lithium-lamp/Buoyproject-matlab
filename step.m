function [L, theta, v] = step(consts, waveinterval, p, theta, dL, h, v)
    m = consts(1);
    k = consts(2);
    r = consts(3);
    rho = consts(4);
    g = consts(5);

    x0 = (p + dL)*sind(theta);
    y0 = (p + dL)*cosd(theta);

    vx0 = v(1);
    vy0 = v(2);
    
    %waveinterval
    d1 = mean(waveinterval);
    Ffy = 0;
    Ffx = 0;

    Fflyt = 0;

    Fg = m * g;
    
    if y0 - r > max(waveinterval(:))
        Fflyt = 0;
    elseif y0 <= min(waveinterval(:))
        Fflyt = rho*g * abs(max(waveinterval(:))-y0);
        Ffx = -30;
    else
        temp = 2*sqrt((r^2) - ((d1-y0)^2));
        %A = 0.1;
        A = real((r^2) * (asin(temp) - temp*sqrt(1 - temp^2)));
        Fflyt = rho*A*g;
        Ffx = -30 * A;
    end
    
    Ffy = abs(real(Fflyt));

    Fs = k * dL;
    if dL <= 0
        Fs = 0;
    end

    Fsx = Fs*sind(theta);

    Fsy = abs(Fs*cosd(theta));

    FxTot = real(Ffx - Fsx);  %Ffx - Fsx;

    FyTot= real(Ffy - Fsy - Fg);

    %Ffx - Fsx = total force X
    %Ffy - Fg - Fsy = total force Y

    ax = (1/m) * FxTot;
    ay = (1/m) * FyTot;
        
    vx = vx0 + h * ax;
    vy = vy0 + h * ay;

    v = [vx vy];
    
    x = x0 + h * vx;
    y = y0 + h * vy;
   
    L = sqrt(x^2 + y^2);
    if L > 4 * p
        L = 4 * p;
    end

    theta = atan(x/y) * 30;
end