% 8 September 2016
% Driver script to run foucault pendulum simulation

clearvars
clc
close all

%% define constants
constants.Omega = 7.2921158553e-5; % rad/sec earth angular velocity
% constants.Omega = 2*pi/(86400/6);
constants.mu = 3.986004418e14; % m^3/sec
% % original Foucault Pendulum
% constants.L = 67; % meters
% constants.m = 28; % kilograms
% constants.beta = 48.846222*pi/180; % Latitude for the Pantheon, Paris 
constants.L = 100;
constants.m = 100;
constants.beta = 90*pi/180; % latitude of pivot location on Earth
constants.Re = 6378.137 * 1e3; % meters radius of the Earth
constants.g = 9.7976432222; % mean g at equator in meters/sec^2
constants.Cbeta = [cos(constants.beta)^2                    0   -sin(constants.beta)*cos(constants.beta);...
                   0                                        1              0                          ;...
                   -sin(constants.beta)*cos(constants.beta) 0   sin(constants.beta)^2];
constants.S = hat_map(constants.Omega*(ROT2(-constants.beta)'*[0;0;1])); 

m = constants.m;
Len = constants.L;
S = constants.S;
Omega = constants.Omega;
Cbeta = constants.Cbeta;
Re = constants.Re;

%% simulation parameters
tspan = [0:0.1:200]; % seconds
pos_initial = ROT2(45*pi/180)*[-1;0;0];
vel_initial = [0;0;0];

initial_condition = [pos_initial;vel_initial];
ode_options = odeset('RelTol',1e-9,'AbsTol',1e-9);

%% call ODE
[t_full,state_full] = ode45(@(t,state)foucault_ode(t,state,constants),tspan,initial_condition,ode_options);
[t_len,state_len] = ode45(@(t,state)foucault_ode_length(t,state,constants),tspan,initial_condition,ode_options);
[t_rot,state_rot] = ode45(@(t,state)foucault_ode_rot(t,state,constants),tspan,initial_condition,ode_options);

pos_full = state_full(:,1:3); % direction of mass in body frame
vel_full = state_full(:,4:6);
pend_pos_full = constants.L*pos_full; % location of mass in body frame

pos_len = state_len(:,1:3); % direction of mass in body frame
vel_len = state_len(:,4:6);
pend_pos_len = constants.L*pos_len; % location of mass in body frame

pos_rot = state_rot(:,1:3); % direction of mass in body frame
vel_rot = state_rot(:,4:6);
pend_pos_rot = constants.L*pos_rot; % location of mass in body frame

%% calculate the total energy of the pendulum and make sure it's consistent
T_full = zeros(length(tspan),1);
V_full = zeros(length(tspan),1);
L_full = zeros(length(tspan),1);
E_full = zeros(length(tspan),1);

T_len = zeros(length(tspan),1);
V_len = zeros(length(tspan),1);
L_len = zeros(length(tspan),1);
E_len = zeros(length(tspan),1);

T_rot = zeros(length(tspan),1);
V_rot = zeros(length(tspan),1);
L_rot = zeros(length(tspan),1);
E_rot = zeros(length(tspan),1);

% calculate total energy
for ii = 1:length(tspan)
    body_pos_full = constants.Re*[1;0;0]+constants.L*pos_full(ii,:)';
    body_pos_len = constants.Re*[1;0;0]+constants.L*pos_len(ii,:)';
    body_pos_rot = constants.Re*[1;0;0]+constants.L*pos_rot(ii,:)';
    
    % need the kinetic energy in the inertial frame
    T_full(ii) = 1/2*m*Len^2*norm(vel_full(ii,:))^2 + ...
            m*Len*vel_full(ii,:)*S*body_pos_full + ...
            1/2*m*Omega^2*body_pos_full'*Cbeta*body_pos_full; 
    V_full(ii) = - constants.m*constants.g*constants.Re^2 / norm(body_pos_full);
    L_full(ii) = T_full(ii)-V_full(ii);
    E_full(ii) = T_full(ii)+V_full(ii);
    
    T_len(ii) = 1/2*m*Len^2*norm(vel_len(ii,:))^2 + ...
            m*Len*vel_len(ii,:)*S*body_pos_len + ...
            1/2*m*Omega^2*body_pos_len'*Cbeta*body_pos_len; 
    V_len(ii) = - constants.m*constants.g*constants.Re^2 / norm(body_pos_len);
    L_len(ii) = T_len(ii)-V_len(ii);
    E_len(ii) = T_len(ii)+V_len(ii);
    
    T_rot(ii) = 1/2*m*Len^2*norm(vel_rot(ii,:))^2; 
    V_rot(ii) = - constants.m*constants.g*constants.Re^2 / norm(body_pos_rot);
    L_rot(ii) = T_rot(ii)-V_rot(ii);
    E_rot(ii) = T_rot(ii)+V_rot(ii);
    
end

% energy variation
E_diff_full = abs(E_full - E_full(1)); 
E_diff_len = abs(E_len - E_len(1)); 
E_diff_rot = abs(E_rot - E_rot(1)); 

%% plot outputs
fontsize = 18;
fontname = 'Times';

e_fig = figure;
grid on;hold on
plot(t_full,abs(E_diff_full./E_full))
plot(t_len,abs(E_diff_len./E_len))
plot(t_rot,abs(E_diff_rot./E_rot))

title('Relative Energy Difference','interpreter','latex','FontName',fontname,'FontSize',fontsize);
xlabel('Time (sec)','interpreter','latex','FontName',fontname,'FontSize',fontsize);
ylabel('$\Delta E / E$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
e_fig_leg = legend('Full EOMS','$ L << r $','$ r \Omega^2 << g $');
set(e_fig_leg,'interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

% 2-D projections
pos_fig = figure;

% ground track of pendulum (b2 vs b3 frame)
subplot(2,2,1)
grid on;hold all
plot(pend_pos_full(:,2),pend_pos_full(:,3))
plot(pend_pos_len(:,2),pend_pos_len(:,3))
plot(pend_pos_rot(:,2),pend_pos_rot(:,3))
title('$b_2$ vs $b_3$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

% vertical frame
subplot(2,2,3)
grid on;hold all
plot(pend_pos_full(:,2),pend_pos_full(:,1))
plot(pend_pos_len(:,2),pend_pos_len(:,1))
plot(pend_pos_rot(:,2),pend_pos_rot(:,1))
title('$b_2$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

subplot(2,2,4)
grid on;hold all
plot(pend_pos_full(:,3),pend_pos_full(:,1))
plot(pend_pos_len(:,3),pend_pos_len(:,1))
plot(pend_pos_rot(:,3),pend_pos_rot(:,1))
title('$b_3$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
pos_fig_leg = legend('Full EOMS','$ L << r $','$ r \Omega^2 << g $');
set(pos_fig_leg,'interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

% animation
body_animation(t_full,pos_full,vel_full,constants)