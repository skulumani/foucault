import numpy as np

def hat_map(vec):
    """Linear map from R^3 to so(3)

    Inputs:
        - vec - 3x1 numpy array

    Outputs:
        - mat - 3x3 skew-symmetric numpy array
    """

    mat = np.zeros([3,3])
    
    mat[0,1] = -vec[2]
    mat[0,2] = vec[1]
    mat[1,0] = vec[2]
    mat[1,2] = -vec[0]
    mat[2,0] = -vec[1]
    mat[2,1] = vec[0]

    return mat

def vee_map(mat):
    """Linear map from so(3) to R^3

    Inputs:
        - mat - 3x3 numpy array

    Outputs:
        - vec - 3x1 numpy array
    """

    x1 = mat[2,1]-mat[1,2]
    x2 = mat[0,2] - mat[2,0]
    x3 = mat[1,0]-mat[0,1]

    vec = 1.0/2*np.array([x1,x2,x3])

    return vec