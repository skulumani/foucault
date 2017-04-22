% 8 September 2016
% Driver script to run foucault pendulum simulation

clearvars
clc
close all

%% define constants
constants = load_constants;

m = constants.m;
Len = constants.L;
S = constants.S;
Omega = constants.Omega;
Cbeta = constants.Cbeta;
Re = constants.Re;

%% simulation parameters
tspan = [0:0.01:60]; % seconds
pos_initial = ROT2(90*pi/180)*[-1;0;0];
vel_initial = [0.5;0;0];

% qdot should be perpendicular to q

initial_condition = [pos_initial;vel_initial];
ode_options = odeset('RelTol',1e-13,'AbsTol',1e-13);

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
plot_outputs(t_full,pos_full,vel_full,constants) % without L applied (direction only)

type = 'none';
filename = 'pend';

% animation
% body_animation(t_full,pos_full,vel_full,constants,type,strcat(filename,'_body'))
% inertial_animation(t_full,pos_full,vel_full,constants,type,strcat(filename,'_inertial'))