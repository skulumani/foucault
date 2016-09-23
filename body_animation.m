% 23 September 2016
% animation for foucault pendulum
function body_animation(t,q,qd,constants)
% draw position of pendulum in the body frame

% body frame reference frame
b1 = constants.L*[1;0;0];
b2 = constants.L*[0;1;0];
b3 = constants.L*[0;0;1];

fig_handle = figure();

range=1.1*(constants.L);
axis([-range range -range range -range range]);
axis square;
grid on,hold on,
title('Foucault Pendulum')
xlabel('b_2')
ylabel('b_3')
zlabel('b_1')

traj = constants.L*q;

% loop over time
for ii = 1:10:length(t)
    cla
    % compute the position of the pendulum mass (L q)
    pos = traj(ii,:);
    
    xcoord = pos(2);
    ycoord = pos(3);
    zcoord = pos(1);
    
    % draw the rotating frame
    line([0 b1(1)],[0 b1(2)],[0 b1(3)],'color','r','linewidth',1)
    line([0 b2(1)],[0 b2(2)],[0 b2(3)],'color','g','linewidth',1)
    line([0 b3(1)],[0 b3(2)],[0 b3(3)],'color','b','linewidth',1)
    
    % plot trajectory through space
    
    if ii < 100
        ind = 1:1:ii;
    else 
        ind = ii-100+1:1:ii;
    end
    
    % pendulum mass
    plot3([0 xcoord],[0 ycoord],[0 zcoord],'MarkerSize',20,'Marker','.','LineWidth',1,'Color','b');
    
    plot3(traj(ind,2),traj(ind,3),traj(ind,1),'Marker','.','MarkerSize',1,'color','k');
    % ground trace
    plot3(traj(1:ii,2),traj(1:ii,3),(-constants.L-0.1*constants.L)*ones(ii,1),'Marker','.','color','g','MarkerSize',1);
    drawnow;
end