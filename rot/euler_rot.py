# Start of rotation kinematics function
import numpy as np
from numpy import cos,sin

def ROT1(alpha):
    """Elementary euler rotation about the first axis

    This assumes a column vector notation. b = rot1*a

    Inputs: 
        - alpha - rotation angle (rad)

    Outputs:
        - rot1 - 3x3 rotation matrix 
    """

    cos_alpha = cos(alpha);
    sin_alpha = sin(alpha);

    rot1 = np.array([
        [1,0,0],
        [0,cos_alpha,-sin_alpha],
        [0,sin_alpha,cos_alpha]
        ]);

    return rot1

def ROT2(beta):
    """Elementary euler rotation about the second axis

    This assumes a column vector notation. b = rot2*a

    Inputs: 
        - beta - rotation angle (rad)

    Outputs:
        - rot2 - 3x3 rotation matrix 
    """
    
    cos_beta = cos(beta);
    sin_beta = sin(beta);

    rot2 = np.array([
        [cos_beta,0,sin_beta],
        [0,1,0],
        [-sin_beta,0,cos_beta]
        ]);

    return rot2

def ROT3(gamma):
    """Elementary euler rotation about the third axis

    This assumes a column vector notation. b = rot3*a

    Inputs: 
        - gamma - rotation angle (rad)

    Outputs:
        - rot3 - 3x3 rotation matrix 
    """
    
    cos_gamma = cos(gamma);
    sin_gamma = sin(gamma);

    rot3 = np.array([
        [cos_gamma,-sin_gamma,0],
        [sin_gamma,cos_gamma,0],
        [0,0,1]
        ]);

    return rot3
