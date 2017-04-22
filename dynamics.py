import numpy as np
import kinematics.attitude as att
import pdb 
class Pendulum(object):
    """Foucault pendulum dynamics

    """

    def __init__(self, Omega=7.2921158553e-5, L=100, m=100, beta=40*np.pi/180):
        """Initialize the foucault pendulum
        
        Parameters:
            Omega - Angular velocity of the Earth or the rotating frame rad/sec
            L - length of the pendulum in meters
            m - mass of pendulum in kilograms
            beta - latitude of pivot point in degrees
            Re - radius of the earth in meters
            g - gravitational acceleration of Earth in meters per second**2
            Cbeta - transformation matrix from dynamics
            S - another matrix from the dynamcis
        """

        # original Foucault Pendulum
        # constants.L = 67; % meters
        # constants.m = 28; % kilograms
        # constants.beta = 48.846222*pi/180; % Latitude for the Pantheon, Paris 
        self.Omega = Omega
        self.L = L
        self.m = m
        self.beta = beta
        self.Re = 6378.137 * 1e3
        self.g = 9.7976432222
        self.Cbeta = np.array( [[np.cos(beta)**2, 0, -np.sin(beta)*np.cos(beta)],
                            [0,1,0],
                            [-np.sin(beta)*np.cos(beta), 0, np.sin(beta)**2]])

        self.mu = 3.986004418e14 # m^3/sec

        self.S = att.hat_map(Omega*(att.rot2(-beta, 'c').T.dot(np.array([0,0,1])))) 

    def nl_ode(self, state, t):
        """Nonlinear EOMs

        """
        m = self.m
        L = self.L
        S = self.S
        Omega = self.Omega
        Re = self.Re
        g = self.g
        Cbeta = self.Cbeta

        pos = state[0:3]
        vel = state[3:6]

        proj_mat = np.eye(3) - np.outer(pos, pos)

        body_pos = Re * np.array([1, 0, 0]) + L * pos

        pos_dot = vel
        vel_dot = -1 / m / L**2 * ( m*L**2*np.linalg.norm(vel)**2*pos + 2*m*L**2*proj_mat.dot(S).dot(vel)
                                    - m*L*Omega**2*proj_mat.dot(Cbeta).dot(body_pos) + m*g*Re**2*L*proj_mat.dot(body_pos)/np.linalg.norm(body_pos)**3)
        
        state_dot = np.hstack((pos_dot, vel_dot))

        return state_dot
    
    def len_ode(self, state, t):
        """Length assumption - Earth radius is much larger than the pendulum length

        """

        m = self.m
        L = self.L
        S = self.S
        Omega = self.Omega
        Re = self.Re
        g = self.g
        Cbeta = self.Cbeta

        pos = state[0:3]
        vel = state[3:6]

        proj_mat = np.eye(3) - np.outer(pos, pos)

        pos_dot = vel
        vel_dot = -1/m/L**2 * (m*L**2*np.linalg.norm(vel)**2*pos + 2*m*L**2*proj_mat.dot(S).dot(vel) 
                        - m*L*Re*Omega**2*proj_mat.dot(Cbeta).dot(np.array([1,0,0])) + m*g*L*proj_mat.dot(np.array([1,0,0])))

        state_dot = np.hstack((pos_dot, vel_dot))

        return state_dot

    def rot_ode(self, state, t):
        """Length and Rotation assumption - Earth is large and the rotation is slowish

        """
        
        m = self.m
        L = self.L
        S = self.S
        Omega = self.Omega
        Re = self.Re
        g = self.g

        pos = state[0:3]
        vel = state[3:6]

        proj_mat = np.eye(3) - np.outer(pos, pos)

        pos_dot = vel
        vel_dot = -1/m/L**2 * (m*L**2*np.linalg.norm(vel)**2*pos + 2*m*L**2*proj_mat*S*vel 
                        + m*g*L*proj_mat*np.array([1,0,0]))

        state_dot = np.hstack((pos_dot, vel_dot))

        return state_dot

    def nl_energy(self, state, time):
        """Compute the energy for the full Nonlinear EOMs

        """

        # extract out the constants we need
        Cbeta = self.Cbeta
        S = self.S
        Omega = self.Omega
        Len = self.L
        m = self.m
        Re = self.Re
        g = self.g

        T = np.zeros(state.shape[0])
        V = np.zeros(state.shape[0])
        L = np.zeros(state.shape[0])
        E = np.zeros(state.shape[0])
        
        q = state[:,0:3]
        qd = state[:, 3:6]
        
        for ii in range(state.shape[0]):
            body_pos = Re*np.array([1, 0, 0]) + Len*q[ii,:]

            T[ii] = (1/2 *m*Len**2*np.linalg.norm(qd[ii,:])**2 + m*Len*qd[ii,:].dot(S).dot(body_pos)
                    + 1/2*m*Omega**2*body_pos.dot(Cbeta).dot(body_pos))

            V[ii] = - m*g*Re**2 / np.linalg.norm(body_pos)

            L[ii] = T[ii] - V[ii]
            E[ii] = T[ii] + V[ii]


        return (T, V, L, E)

    def len_energy(self, state, time):
        """Compute the energy for the lenght based reduced  EOMs

        """

        # extract out the constants we need
        Cbeta = self.Cbeta
        S = self.S
        Omega = self.Omega
        Len = self.L
        m = self.m
        Re = self.Re
        g = self.g

        T = np.zeros(state.shape[0])
        V = np.zeros(state.shape[0])
        L = np.zeros(state.shape[0])
        E = np.zeros(state.shape[0])
        
        q = state[:,0:3]
        qd = state[:, 3:6]
        
        for ii in range(state.shape[0]):
            body_pos = Re*np.array([1, 0, 0]) + Len*q[ii,:]

            T[ii] = (1/2 *m*Len**2*np.linalg.norm(qd[ii,:])**2 + m*Len*qd[ii,:].dot(S).dot(body_pos)
                    + 1/2*m*Omega**2*body_pos.dot(Cbeta).dot(body_pos))

            V[ii] = - m*g*Re**2 / np.linalg.norm(body_pos)

            L[ii] = T[ii] - V[ii]
            E[ii] = T[ii] + V[ii]


        return (T, V, L, E)
