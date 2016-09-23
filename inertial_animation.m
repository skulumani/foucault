% 23 September 2016
% animation for foucault pendulum expressed in inertial frame
function inertial_animation(t,q,qd,constants)
% draw position of pendulum in the body frame

fig_handle = figure();

range=1.1*(constants.L);
axis([-range range -range range -range range]);
axis square;
grid on,hold on,
title('Foucault Pendulum')
xlabel('e_1')
ylabel('e_2')
zlabel('e_3')

% body frame reference frame
e1 = constants.L*[1;0;0];
e2 = constants.L*[0;1;0];
e3 = constants.L*[0;0;1];

traj = constants.L*q;
traj_inertial = zeros(size(traj));

% loop over time
for ii = 1:1:length(t)
    cla
    % compute the rotation from body frame to inertial frame
    R_b2i = ROT2(-constants.beta)*ROT3(constants.Omega*t(ii));
    R_i2b = R_b2i';
    
    % compute the position of the pendulum mass (L q)
    pos = R_b2i*traj(ii,:)';
    traj_inertial(ii,:) = pos';
    
    xcoord = pos(2);
    ycoord = pos(3);
    zcoord = pos(1);
    
    % rotate the body frame axes and plot
    b1 = R_b2i*e1;
    b2 = R_b2i*e2;
    b3 = R_b2i*e3;
    
    % draw the rotating frame
    line([0 b1(1)],[0 b1(2)],[0 b1(3)],'color','r','linewidth',1)
    line([0 b2(1)],[0 b2(2)],[0 b2(3)],'color','g','linewidth',1)
    line([0 b3(1)],[0 b3(2)],[0 b3(3)],'color','b','linewidth',1)
    
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