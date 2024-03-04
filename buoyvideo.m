function [] = buoyvideo(buoypos, r, wavefunc, originalvals, N)

p0 = originalvals(1); theta0 = originalvals(2); dL0 = originalvals(3);



%distance from 0, 0

x = (p0 + dL0) * sind(theta0);
y = (p0 + dL0) * cosd(theta0);



circleangle = linspace(0, 2*pi, N);
Ax = 0.1 * cos(circleangle); %anchor point
Ay = 0.1 * sin(circleangle) - y; %anchor point



%anchor point of fastener to seafloor is 0, -y

axislimits = [-6 6 -6 6];

%groundX = [];

seafloorX = [-5 -5 5 5 -5];
seafloorY = [(-y - 0.1) -y -y (-y - 0.1) (-y - 0.1)];


videoObject = VideoWriter('buoyvideo', 'MPEG-4');
videoObject.FrameRate = 60;
open(videoObject)
for ii = 1:N

    plot(Ax, Ay, '--', 0 ,-y, 'ko')
    axis equal
    hold on

    
    Bx = r * cos(circleangle) + buoypos(ii,1);
    By = r * sin(circleangle) + buoypos(ii,2);
    plot(Bx, By, '-', buoypos(ii,1), buoypos(ii,2), 'ko')

    fill(Bx, By, 'r')

    plot(-5:0.01:5, wavefunc(-5:0.01:5,ii));

    dL = sqrt(buoypos(ii,1)^2 + buoypos(ii,2)^2);
    
    ang=atan(buoypos(ii,1)/buoypos(ii,2));

    xp0 = dL*sin(ang);
    yp0 = dL*cos(ang);
    
    plot([0, buoypos(ii,1)], [-y, buoypos(ii,2)], 'k', 'linewidth', 2)
    plot([buoypos(ii,1), buoypos(ii,1)], [buoypos(ii,2), buoypos(ii,2)], 'ko', 'linewidth', 1)

    fill(seafloorX, seafloorY, 'g')

    axis(axislimits)
    axis off
    hold off
    frames(ii) = getframe;
end

writeVideo(videoObject, frames)

close(videoObject)

end