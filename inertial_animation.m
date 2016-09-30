% 23 September 2016
% animation for foucault pendulum expressed in inertial frame
function inertial_animation(t,q,qd,constants)
% draw position of pendulum in the body frame

fig_handle = figure();

range=1.1*(constants.L);
axis([-range range -range range -range range]);
axis square;
grid on,hold on,
title('Foucault Pendulum - Inertial Frame')
xlabel('e_1')
ylabel('e_2')
zlabel('e_3')

% body frame reference frame
e1 = constants.L*[1;0;0];
e2 = constants.L*[0;1;0];
e3 = constants.L*[0;0;1];

traj = constants.L*q;
traj_inertial = zeros(size(traj));

% draw the inertial frame
axis_data = get(gca);
xmin = axis_data.XLim(1);
xmax = axis_data.XLim(2);
ymin = axis_data.YLim(1);
ymax = axis_data.YLim(2);
zmin = axis_data.ZLim(1);
zmax = axis_data.ZLim(2);

% loop over time
for ii = 1:1:length(t)
    cla
    % compute the rotation from body frame to inertial frame
    R_i2b = ROT3(constants.Omega*t(ii))*ROT2(-constants.beta);
    R_b2i = R_i2b';
    
    % compute the position of the pendulum mass (L q)
    pos = R_b2i'*traj(ii,:)';
    traj_inertial(ii,:) = pos';
    
    xcoord = pos(2);
    ycoord = pos(3);
    zcoord = pos(1);
    
    % rotate the body frame axes and plot
    b1 = R_i2b*e1;
    b2 = R_i2b*e2;
    b3 = R_i2b*e3;
    
    % draw the rotating frame
    line([0 b1(1)],[0 b1(2)],[0 b1(3)],'color','r','linewidth',1)
    text(b1(1),b1(2),b1(3),'$\hat{b}_1$','interpreter','latex')
    line([0 b2(1)],[0 b2(2)],[0 b2(3)],'color','g','linewidth',1)
    text(b2(1),b2(2),b2(3),'$\hat{b}_2$','interpreter','latex')
    line([0 b3(1)],[0 b3(2)],[0 b3(3)],'color','b','linewidth',1)
    text(b3(1),b3(2),b3(3),'$\hat{b}_3$','interpreter','Latex')
    
    % inertial frame
    plot3([xmin,xmax],[0 0],[0 0],'red','Linewidth',1); plot3(xmax,0,0,'r>','Linewidth',1.5);
    plot3([0 0],[ymin,ymax],[0 0],'green','Linewidth',1); plot3(0,ymax,0,'g>','Linewidth',1.5);
    plot3([0 0],[0 0],[zmin,zmax],'blue','Linewidth',1); plot3(0,0,zmax,'b^','Linewidth',1.5);
    
    % draw the pendulum mass in the inertial frame
    plot3([0 pos(1)],[0 pos(2)],[0 pos(3)],'MarkerSize',20,'Marker','.','LineWidth',1,'Color','b')
    
    % plot trajectory through space
    
    if ii < 100
        ind = 1:1:ii;
    else 
        ind = ii-100+1:1:ii;
    end
    
    plot3(traj_inertial(ind,1),traj_inertial(ind,2),traj_inertial(ind,3),'Marker','.','MarkerSize',1,'color','k');
    
    drawnow;
end