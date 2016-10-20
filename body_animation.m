% 23 September 2016
% animation for foucault pendulum
function body_animation(t,q,qd,constants,type,filename)

% draw position of pendulum in the body frame

% body frame reference frame
% Rotate body frame to match matlab figure (gravity is downward -z
% direction)
b1 = constants.L*[1;0;0];
b2 = constants.L*[0;1;0];
b3 = constants.L*[0;0;1];

b1 = ROT3(-pi/2)*ROT2(-pi/2)*b1;
b2 = ROT3(-pi/2)*ROT2(-pi/2)*b2;
b3 = ROT3(-pi/2)*ROT2(-pi/2)*b3;

fig_handle = figure();

range=1.1*(constants.L);
axis([-range range -range range -range range]);
axis square;
grid on,hold on,
title('Foucault Pendulum - Body-fixed frame')
xlabel('b_2')
ylabel('b_3')
zlabel('b_1')

traj = constants.L*q;

% draw the inertial frame
axis_data = get(gca);
xmin = axis_data.XLim(1);
xmax = axis_data.XLim(2);
ymin = axis_data.YLim(1);
ymax = axis_data.YLim(2);
zmin = axis_data.ZLim(1);
zmax = axis_data.ZLim(2);

switch type
    case 'gif'
        f = getframe;
        [im,map] = rgb2ind(f.cdata,256,'nodither');
    case 'movie'
        % M(1:length(tspan))= struct('cdata',[],'colormap',[]);
        nFrames = length(t);
        vidObj = VideoWriter([filename '.avi']);
        vidObj.Quality = 100;
        vidObj.FrameRate = 60;
        open(vidObj);
end

% loop over time
for ii = 1:1:length(t)
    cla
    % compute the position of the pendulum mass (L q)
    pos = traj(ii,:);
    
    xcoord = pos(2);
    ycoord = pos(3);
    zcoord = pos(1);
    
    % draw the rotating frame
    line([0 b1(1)],[0 b1(2)],[0 b1(3)],'color','r','linewidth',1)
    text(b1(1),b1(2),b1(3),'$\hat{b}_1$','interpreter','latex')
    line([0 b2(1)],[0 b2(2)],[0 b2(3)],'color','g','linewidth',1)
    text(b2(1),b2(2),b2(3),'$\hat{b}_2$','interpreter','latex')
    line([0 b3(1)],[0 b3(2)],[0 b3(3)],'color','b','linewidth',1)
    text(b3(1),b3(2),b3(3),'$\hat{b}_3$','interpreter','Latex')
    
    % arrow head
    plot3(b1(1),b1(2),b1(3),'r>','Linewidth',1.5)
    plot3(b2(1),b2(2),b2(3),'g>','Linewidth',1.5)
    plot3(b3(1),b3(2),b3(3),'b^','Linewidth',1.5)
    
    % inertial frame
%     plot3([xmin,xmax],[0 0],[0 0],'red','Linewidth',1); plot3(xmax,0,0,'r>','Linewidth',1.5);
%     plot3([0 0],[ymin,ymax],[0 0],'green','Linewidth',1); plot3(0,ymax,0,'g>','Linewidth',1.5);
%     plot3([0 0],[0 0],[zmin,zmax],'blue','Linewidth',1); plot3(0,0,zmax,'b^','Linewidth',1.5);

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
    
    % save animation 
    switch type
        case 'gif'
            
            frame = getframe(1);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            outfile = [filename '.gif'];
            
            % On the first loop, create the file. In subsequent loops, append.
            if ii==1
                imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
            else
                imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
            end
        case 'movie'
            % M(ii)=getframe(gcf,[0 0 560 420]); % leaving gcf out crops the frame in the movie.
            writeVideo(vidObj,getframe(gca));
        otherwise
    end
end

% Output the movie as an avi file
switch type
    case 'gif'
        fprintf('Finished animation\n')
    case 'movie'
        %movie2avi(M,[filename '.avi']);
        close(vidObj);
        fprintf('Finished animation - movie saved\n')
    otherwise
        
end
