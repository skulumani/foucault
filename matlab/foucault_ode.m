% 8 September 2016
% Full NL ODE function for foucault pendulum

function [state_dot] = foucault_ode(t,state,constants)

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

body_pos = Re*[1;0;0]+L*pos; % position of pendulum in body frame

pos_dot = vel;
vel_dot = -1/m/L^2 * (m*L^2*norm(vel)^2*pos + 2*m*L^2*proj_mat*S*vel - m*L*Omega^2*proj_mat*Cbeta*body_pos ...
        + m*g*Re^2*L*proj_mat*body_pos/norm(body_pos)^3);
    
state_dot = [pos_dot;vel_dot];


