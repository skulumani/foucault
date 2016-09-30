% 8 September 2016
% Driver script to run foucault pendulum simulation

clearvars
clc
close all

%% define constants
constants.eom = 'full'; % full or len or rot for simplifications
% constants.Omega = 7.2921158553e-5; % rad/sec earth angular velocity
constants.Omega = 7.2921158553e-5;
constants.mu = 3.986004418e14; % m^3/sec
% % original Foucault Pendulum
% constants.L = 67; % meters
% constants.m = 28; % kilograms
% constants.beta = 48.846222*pi/180; % Latitude for the Pantheon, Paris 
constants.L = 100;
constants.m = 100;
constants.beta = 40*pi/180; % latitude of pivot location on Earth
constants.Re = 6378.137 * 1e3; % meters radius of the Earth
% constants.g = 9.7976432222; % mean g at equator in meters/sec^2
constants.g = 9.7976432222;
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
pos_initial = ROT2(90*pi/180)*[-1;0;0];
vel_initial = [0;0.01;0];

initial_condition = [pos_initial;vel_initial];
ode_options = odeset('RelTol',1e-9,'AbsTol',1e-9);

%% call ODE
[t_full,state_full] = ode45(@(t,state)foucault_ode(t,state,constants),tspan,initial_condition,ode_options);
% [t_len,state_len] = ode45(@(t,state)foucault_ode_length(t,state,constants),tspan,initial_condition,ode_options);
% [t_rot,state_rot] = ode45(@(t,state)foucault_ode_rot(t,state,constants),tspan,initial_condition,ode_options);

pos_full = state_full(:,1:3); % direction of mass in body frame
vel_full = state_full(:,4:6);
pend_pos_full = constants.L*pos_full; % location of mass in body frame

% pos_len = state_len(:,1:3); % direction of mass in body frame
% vel_len = state_len(:,4:6);
% pend_pos_len = constants.L*pos_len; % location of mass in body frame
% 
% pos_rot = state_rot(:,1:3); % direction of mass in body frame
% vel_rot = state_rot(:,4:6);
% pend_pos_rot = constants.L*pos_rot; % location of mass in body frame


%% Plot the outputs
% plot_outputs(t_full,pos_full,vel_full,constants) % without L applied (direction only)

type = 'gif';
filename = 'pend';

% animation
body_animation(t_full,pos_full,vel_full,constants,type,strcat(filename,'_body'))
% inertial_animation(t_full,pos_full,vel_full,constants,type,strcat(filename,'_inertial'))