% 8 September 2016
% Assuming length of pendulum is much less than the Earth

function [state_dot] = foucault_ode_length(t,state,constants)

% extract constants
Omega = constants.Omega;
L = constants.L;
m = constants.m;
Re = constants.Re;
g = constants.g;
Cbeta = constants.Cbeta;
S = constants.S;

% redefine the state
pos = state(1:3,1);
vel = state(4:6,1);

proj_mat = eye(3,3) - pos*pos';

pos_dot = vel;
vel_dot = -1/m/L^2 * (m*L^2*norm(vel)^2*pos + 2*m*L^2*proj_mat*S*vel ...
         - m*L*Re*Omega^2*proj_mat*Cbeta*[1;0;0] + m*g*L*proj_mat*[1;0;0]);
     

state_dot = [pos_dot;vel_dot];