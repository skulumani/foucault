import dynamics
from kinematics import attitude

from scipy import integrate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from plotting import animate_pendulum
import pdb

RelTol = 1e-4
AbsTol = 1e-4

pend = dynamics.Pendulum()
initial_pos = attitude.rot2(40*np.pi/180, 'c').dot(np.array([-1, 0, 0]))
initial_vel = np.array([0.0, 0, 0])

initial_state = np.hstack((initial_pos, initial_vel))
tf = 60 
dt = 0.01
time = np.linspace(0,tf,tf/dt)

# define integration
# state_nl = integrate.odeint(pend.nl_ode, initial_state, time, atol=AbsTol, rtol=RelTol)
# state_len = integrate.odeint(pend.len_ode, initial_state, time, atol=AbsTol, rtol=RelTol)

# use ode class
solver = integrate.ode(pend.nl_ode)
solver.set_integrator('vode', atol=AbsTol, rtol=RelTol).set_initial_value(initial_state, 0)

state_nl = []

while solver.successful() and solver.t < tf:
    solver.integrate(solver.t + dt)
    state_nl.append(solver.y)

state_nl = np.asarray(state_nl)
pdb.set_trace()
T, V, L, E = pend.nl_energy(state_nl, time)


# animate_pendulum(time, state_nl, pend)
