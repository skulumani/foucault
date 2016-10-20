% 14 October 2016
% Driver function to test many initial conditions.
% we want to find irregular motion of the foucault pendulum


%% define constants

rng(0,'twister');
qd_min = 0;
qd_max = 2;

constants = load_constants;

m = constants.m;
Len = constants.L;
S = constants.S;
Omega = constants.Omega;
Cbeta = constants.Cbeta;
Re = constants.Re;

tspan = [0:0.01:60]; % seconds

num_trials = 10;

sim_data = struct('t_full',[],'state_full',[],'initial_condition',[],'constants',[], ...
    'pos_full',[],'vel_full',[],'pend_pos_full',[]);

%% generate random simulations
for ii = 1:num_trials
    % generate random q
    q_rand = rand(3,1);
    q_rand = q_rand ./ norm(q_rand);
    
    % find a random orthogonal qdot
    x = rand(3,1);
    x = x ./ norm(x);
    
    qd_mag = qd_min + (qd_max-qd_min).*rand(1,1);
    qd_rand = qd_mag*cross(q_rand,x);
    
    % sanity check the random q and qd
    
    if dot(q_rand,qd_rand) > 1e-6
        fprintf('q and qd are not orthogonal\n');
        keyboard
    end
         
    pos_initial = q_rand;
    vel_initial = qd_rand;
    
    initial_condition = [pos_initial;vel_initial];
    
    % call ODE
    [t_full,state_full] = ode45(@(t,state)foucault_ode(t,state,constants),tspan,initial_condition,constants.ode_options);
    
    pos_full = state_full(:,1:3); % direction of mass in body frame
    vel_full = state_full(:,4:6);
    pend_pos_full = constants.L*pos_full; % location of mass in body frame
    
    % save to a big data structure
    sim_data(ii).t_full = t_full;
    sim_data(ii).state_full = state_full;
    sim_data(ii).pos_full = pos_full;
    sim_data(ii).vel_full = vel_full;
    sim_data(ii).pend_pos_full = pend_pos_full;
    sim_data(ii).initial_condition = initial_condition;
    sim_data(ii).constants = constants;
end

%% loop to plot
for ii = 1:num_trials
   
   % call plotting function
   plot_outputs(sim_data(ii).t_full,sim_data(ii).pos_full,sim_data(ii).vel_full,sim_data(ii).constants)
   
   keyboard
   close all
end
