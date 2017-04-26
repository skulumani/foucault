import dynamics
from kinematics import attitude, sphere

from scipy import integrate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from plotting import animate_pendulum, plot_pendulum
import pdb

RelTol = 1e-9
AbsTol = 1e-9

pend = dynamics.Pendulum(L=67, m=28, beta=0)
# initial_pos = attitude.rot2(40*np.pi/180, 'c').dot(np.array([-1, 0, 0]))
# initial_vel = sphere.tan_rand(initial_pos)
initial_pos = np.array([-np.sqrt(2)/2, 0, np.sqrt(2)/2])
initial_vel = np.array([0, 0, 0])

# initial position should be orthogonal to the initial velocity
np.testing.assert_almost_equal(initial_pos.dot(initial_vel), 0)

initial_state = np.hstack((initial_pos, initial_vel))
t0 = 0 
tf =3600
dt = 0.01
time = np.linspace(0,tf,tf/dt)
num_steps = np.floor((tf-t0)/dt) + 1
# define integration
# state_nl = integrate.odeint(pend.nl_ode, initial_state, time, atol=AbsTol, rtol=RelTol)
# state_len = integrate.odeint(pend.len_ode, initial_state, time, atol=AbsTol, rtol=RelTol)

# use ode class
solver = integrate.ode(pend.nl_ode)
solver.set_integrator('dopri5', atol=AbsTol, rtol=RelTol)
solver.set_initial_value(initial_state, 0)

# initialize a vector to store the simulation data
state_nl = np.zeros((int(num_steps),int(initial_state.shape[0])))
t = np.zeros(int(num_steps))

t[0] = t0
state_nl[0,:] = initial_state
ii = 1
while solver.successful() and ii < num_steps:
    solver.integrate(solver.t + dt)
    t[ii] = solver.t
    state_nl[ii,:] = solver.y

    ii = ii + 1

T, V, L, E = pend.nl_energy(state_nl, time)

plot_pendulum(t, state_nl, E, pend)
# animate_pendulum(time, state_nl, pend)
