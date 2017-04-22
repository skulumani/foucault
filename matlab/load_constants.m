% load constants for Foucault pendulum

function [constants] = load_constants()
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

constants.ode_options = odeset('RelTol',1e-13,'AbsTol',1e-13);
