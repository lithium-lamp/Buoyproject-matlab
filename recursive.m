function [buoypos] = recursive(consts, wavefunc, originalvals, h, N)
    p = originalvals(1);
    theta = originalvals(2);
    dL = originalvals(3);
    vx = originalvals(4);
    vy = originalvals(5);

    v = [vx vy];

    x = (p + dL)*sind(theta);
    y = (p + dL)*cosd(theta);
    r = consts(3);

    smallval = 1/9;
    
    buoypos = zeros(2, N);

    L = p + dL;

    for i=1:N
        [L, theta, v] = step(consts, wavefunc((x-r):smallval:(x+r),(i-1)), p, theta, L - p, h, v);
        
        x = L*sind(theta);
        y = L*cosd(theta);

        buoypos(1,i) = x;
        buoypos(2,i) = y;
    end
end