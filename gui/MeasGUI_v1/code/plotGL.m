function plotGL(grid,ax)

% setup the grid
% x = -1:grid:1;
% y = -1:grid:1;
% [X Y] = meshgrid(x,y);
% GLtmp = X(:) + 1i.*Y(:);
% AllGL = GLtmp(find(abs(GLtmp)<=1));

GL = [];
Mag = 0:grid:1; % magnitude grid
if max(Mag) ~= 1 % add magnitude of 1
    Mag(end+1) = 1;
end

for Idx = 1:length(Mag) % calculate radians for each magnitude
    if Mag(Idx) > 0 % if mag == 0, then one point
        agrid = 2*asin(0.5*grid/Mag(Idx)); % radian grid
        Rad = 0:agrid:(2*pi-0.25*agrid);
    else
        Rad = 0;
    end
    GL = cat(2,GL,Mag(Idx)*exp(j*Rad));
%     plot(real(Mag(Idx)*exp(j*Rad)),imag(Mag(Idx)*exp(j*Rad)),'.');
end

% select 50 ohm point
axes(ax);
plot(0,0,'s','Color',[0.7 0.1 0],'MarkerSize',8);
plot(0,0,'o','Color',[0.15 0.2 0.8],'MarkerSize',8,'LineWidth',2);

% plot all gamma
plot(real(GL),imag(GL),'.','Color',[0.15 0.45 0.15]);

h = get(ax, 'Children');

% clear fundamental 50ohm point
set(h(2:3),'UserData',[]);
set(h(2:3),'XData',[]);
set(h(2:3),'YData',[]);