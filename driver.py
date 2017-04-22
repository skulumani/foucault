import dynamics
from kinematics import attitude

from scipy import integrate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

RelTol = 1e-9
AbsTol = 1e-9

pend = dynamics.Pendulum()
initial_pos = attitude.rot2(40*np.pi/180, 'c').dot(np.array([-1, 0, 0]))
initial_vel = np.array([0.0, 0, 0])

initial_state = np.hstack((initial_pos, initial_vel))
tf = 1000
dt = 0.01
time = np.linspace(0,tf,tf/dt)

state_nl = integrate.odeint(pend.nl_ode, initial_state, time, atol=AbsTol, rtol=RelTol)
state_len = integrate.odeint(pend.len_ode, initial_state, time, atol=AbsTol, rtol=RelTol)

T, V, L, E = pend.nl_energy(state_nl, time)

# extract out the state
pend_pos = pend.L * state_nl[:,0:3]

# plot the energy behavior
energy_ax = plt.figure().add_subplot(111)
energy_ax.plot(time, E, label=r'$E$')
energy_ax.set_xlabel('Time')
energy_ax.set_ylabel(r'$E$')
energy_ax.grid(True)

pos_norm_ax = plt.figure().add_subplot(111)
pos_norm_ax.plot(time, np.linalg.norm(state_nl[:,0:3], ord=2, axis=1), label='NL')
pos_norm_ax.set_xlabel('Time')
pos_norm_ax.set_ylabel(r'$||q||$')
pos_norm_ax.grid(True)
pos_norm_ax.legend()

pos_fig, pos_axarr = plt.subplots(2,2)
pos_axarr[0, 0].plot(pend_pos[:,1], pend_pos[:,2])
pos_axarr[0, 0].set_title(r'$b_2$ vs. $b_3$')

pos_axarr[1, 0].plot(pend_pos[:,1], pend_pos[:,0])
pos_axarr[1, 0].set_title(r'$b_2$ vs. $b_1$')

pos_axarr[1, 1].plot(pend_pos[:,2], pend_pos[:,0])
pos_axarr[1, 1].set_title(r'$b_3$ vs. $b_1$')

plt.show()

