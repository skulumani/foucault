import dynamics
from kinematics import attitude

from scipy import integrate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from plotting import animate_pendulum

RelTol = 1e-9
AbsTol = 1e-9

pend = dynamics.Pendulum()
initial_pos = attitude.rot2(40*np.pi/180, 'c').dot(np.array([-1, 0, 0]))
initial_vel = np.array([0.0, 0, 0])

initial_state = np.hstack((initial_pos, initial_vel))
tf = 60 
dt = 0.01
time = np.linspace(0,tf,tf/dt)

state_nl = integrate.odeint(pend.nl_ode, initial_state, time, atol=AbsTol, rtol=RelTol)
state_len = integrate.odeint(pend.len_ode, initial_state, time, atol=AbsTol, rtol=RelTol)

T, V, L, E = pend.nl_energy(state_nl, time)


animate_pendulum(time, state_nl, pend)
