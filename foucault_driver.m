% 8 September 2016
% Driver script to run foucault pendulum simulation

clearvars
clc
close all

%% define constants
constants.Omega = 7.2921158553e-5; % rad/sec earth angular velocity
constants.mu = 3.986004418e14; % m^3/sec
% % original Foucault Pendulum
% constants.L = 67; % meters
% constants.m = 28; % kilograms
% constants.beta = 48.846222*pi/180; % Latitude for the Pantheon, Paris 
constants.L = 100;
constants.m = 1;
constants.beta = pi/2; % latitude of pivot location on Earth
constants.Re = 6378.137 * 1e3; % meters radius of the Earth
constants.g = 9.7976432222; % mean g at equator in meters/sec^2
constants.Cbeta = [cos(constants.beta)^2                    0   -sin(constants.beta)*cos(constants.beta);...
                   0                                        1              0                          ;...
                   -sin(constants.beta)*cos(constants.beta) 0   sin(constants.beta)^2];
constants.S = hat_map(constants.Omega*(ROT2(constants.beta)')'*[0;0;1]); % my ROT matrix assumes row notation

m = constants.m;
Len = constants.L;
S = constants.S;
Omega = constants.Omega;
Cbeta = constants.Cbeta;
Re = constants.Re;

%% simulation parameters
tspan = [0:0.01:100]; % seconds
pos_initial = ROT3(45*pi/180)'*[-1;0;0];
initial_condition = [pos_initial;0;0;0];
ode_options = odeset('RelTol',1e-9,'AbsTol',1e-9);

%% call ODE
[t,state] = ode113(@(t,state)foucault_ode(t,state,constants),tspan,initial_condition,ode_options);
% [t,state] = ode113(@(t,state)foucault_ode_length(t,state,constants),tspan,initial_condition,ode_options);

pos = state(:,1:3); % direction of mass in body frame
vel = state(:,4:6);
pend_pos = constants.L*pos; % location of mass in body frame

T = zeros(length(t),1);
V = zeros(length(t),1);
L = zeros(length(t),1);
E = zeros(length(t),1);

% calculate total energy
for ii = 1:length(t)
    body_pos = constants.Re*[1;0;0]+constants.L*pos(ii,:)';
    
    % need the kinetic energy in the inertial frame
    T(ii) = 1/2*m*Len^2*norm(vel(ii,:))^2 + ...
            m*Len*vel(ii,:)*S*body_pos + ...
            1/2*m*Omega^2*body_pos'*Cbeta*body_pos; 

    V(ii) = - constants.m*constants.g*constants.Re^2 / norm(body_pos);

    L(ii) = T(ii)-V(ii);
    E(ii) = T(ii)+V(ii);
    
end

% energy variation
E_diff = abs(E - E(1)); 

%% plot outputs
fontsize = 18;
fontname = 'Times';

e_fig = figure;
plot(t,E_diff)
grid on
title('Energy Difference','interpreter','latex','FontName',fontname,'FontSize',fontsize);
xlabel('Time (sec)','interpreter','latex','FontName',fontname,'FontSize',fontsize);
ylabel('$\Delta E$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

% 2-D views
pos_fig = figure;
hold all
% ground track of pendulum (b2 vs b3 frame)
subplot(2,2,1)
plot(pend_pos(:,2),pend_pos(:,3))
title('$b_2$ vs $b_3$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
grid on;hold all
set(gca,'FontName',fontname,'FontSize',fontsize);

% vertical frame
subplot(2,2,3)
plot(pend_pos(:,2),pend_pos(:,1))
title('$b_2$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
grid on;hold all
set(gca,'FontName',fontname,'FontSize',fontsize);

subplot(2,2,4)
plot(pend_pos(:,3),pend_pos(:,1))
title('$b_3$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
grid on;hold all
set(gca,'FontName',fontname,'FontSize',fontsize);

% animate pendulum
