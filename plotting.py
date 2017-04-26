import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib import animation, rc
from mpl_toolkits.mplot3d import axes3d

from kinematics import attitude
import pdb

# set matplotlib parameters
rc('font', **{'family':'serif', 'serif':['Computer Modern Roman']})
rc('text', usetex=True)

def animate_pendulum(time, state, pend):
    
    pos = pend.L * state[:, 0:3]

    b1 = pend.L * np.array([1, 0, 0])
    b2 = pend.L * np.array([0, 1, 0])
    b3 = pend.L * np.array([0, 0, 1])

    # rotate reference frame to match figure. Down is in the negative z direction
    b1 = attitude.rot3(-np.pi/2, 'c').dot(attitude.rot2(-np.pi/2, 'c')).dot(b1)
    b2 = attitude.rot3(-np.pi/2, 'c').dot(attitude.rot2(-np.pi/2, 'c')).dot(b2)
    b3 = attitude.rot3(-np.pi/2, 'c').dot(attitude.rot2(-np.pi/2, 'c')).dot(b3)
    
    b_frame = np.stack((b1, b2, b3), axis=1)
    ax_lim = 1.1 * pend.L
    fig = plt.figure()
    ax = axes3d.Axes3D(fig)

    ax.set_xlim3d([-ax_lim, ax_lim])
    ax.set_xlabel(r'$b_2$')
    
    ax.set_ylim3d([-ax_lim, ax_lim])
    ax.set_ylabel(r'$b_3$')

    ax.set_zlim3d([-ax_lim, ax_lim])
    ax.set_zlabel(r'$b_1$')

    ax_colors = ['r', 'g', 'b']

    b_frame_lines = [ax.plot([], [], [], '-', lw=2, c=c)[0] for c in ax_colors]
    pend_line = [ax.plot([], [], [], 'o-')[0]]
    traj = [ax.plot([], [], [], '-')[0]]
    gr_traj = [ax.plot([], [], [], '-', c='g')[0]]

    def init():
        for jj, b_line in enumerate(b_frame_lines):
            xi, yi, zi = b_frame[:, jj]
            b_line.set_data([0, xi], [0, yi])
            b_line.set_3d_properties([0, zi])

        pend_line[0].set_data([], [])
        pend_line[0].set_3d_properties([])

        traj[0].set_data([], [])
        traj[0].set_3d_properties([])

        gr_traj[0].set_data([], [])
        gr_traj[0].set_3d_properties([])

        return b_frame_lines + pend_line + traj + gr_traj

    def animate(ii):
        ii = (10 * ii) % time.shape[0]


        x = pos[ii, 1]
        y = pos[ii, 2]
        z = pos[ii, 0]
        
        # plot the path the pendulum swings through
        if ii < 100:
            ind =  0
        else:
            ind =  ii-100
        
        pend_line[0].set_data([0, x], [0, y])
        pend_line[0].set_3d_properties([0, z])
        
        # draw the trajectory
        traj[0].set_data(pos[ind:ii,1], pos[ind:ii, 2])
        traj[0].set_3d_properties(pos[ind:ii,0])

        gr_traj[0].set_data(pos[:ii,1], pos[:ii, 2])
        gr_traj[0].set_3d_properties(-ax_lim * np.ones_like(pos[:ii,0]))

        return b_frame_lines + pend_line + traj + gr_traj

    anim = animation.FuncAnimation(fig, animate, init_func=init, frames=time.shape[0], interval=1/30*1e3, blit=True)

    plt.show()

def plot_pendulum(time, state, E, pend):


    # extract out the state
    pend_pos = pend.L *state[:,0:3]
    pend_vel = state[:, 3:6]

    # plot the energy behavior
    energy_ax = plt.figure().add_subplot(111)
    energy_ax.plot(time, np.absolute((E-E[0])/ E), label=r'$E$')
    energy_ax.set_xlabel('Time')
    energy_ax.set_ylabel(r'$E$')
    energy_ax.grid(True)

    pos_norm_fig, pos_norm_ax = plt.subplots() 
    pos_norm_ax.plot(time, np.linalg.norm(state[:,0:3], ord=2, axis=1), label='NL')
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

    vel_fig, vel_axarr = plt.subplots()
    vel_axarr.plot(time, np.linalg.norm(pend_vel, axis=1))
    vel_axarr.set_xlabel(r'Time')
    vel_axarr.set_ylabel(r'$||\dot{q}||$')
    vel_axarr.grid(True)
    vel_axarr.set_title(r'Velocity Norm')
    plt.show()
