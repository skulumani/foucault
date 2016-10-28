# Main python driver script
import numpy as np
from rot.euler_rot import ROT2
from rot.dcm import hat_map

# Load packages

# define constants for simulation

def load_constants():
    """
        Load constants for Foucault pendulum

        Set ODE options in here as well

        Think about using a class


    """


    constants = {
    'eom': 'full', # which ODE to run 'full' or 'len' or 'rot'
    'Omega': 7.2921158553e-5, # rad/sec earth angular velocity
    'mu': 3.986004418e14, # m^3/sec Earth gravitional parameter
    'L': 100, # length in meters
    'm': 100, # mass in kg
    'beta': 40*np.pi/180, # latitude for pivot in radians
    'Re': 6378.137 * 1e3, # meters radius of the Earth
    'g': 9.7976432222, # m/sec^2 acceleration due to Gravity
    }

    beta = constants['beta']
    Cbeta = np.array([
        [np.cos(beta)**2, 0, -np.sin(beta)*np.cos(beta)],
        [0,1,0],
        [-np.sin(beta)*np.cos(beta), 0 , np.sin(beta)**2]
        ])
    constants["Cbeta"] = Cbeta

    constants["S"] = hat_map(constants["Omega"]*np.dot(np.transpose(ROT2(-constants["beta"])),np.array([0,0,1]))); 

    return constants

