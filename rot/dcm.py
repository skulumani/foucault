import numpy as np

def hat_map(vector):
    """Linear map from R^3 to so(3)

    Inputs:
        - vector - 3x1 numpy array

    Outputs:
        - matrix - 3x3 skew-symmetric numpy array
    """

    matrix = np.zeros(3,3);

    matrix(0,1) = -vector(2);
    matrix(0,2) = vector(1);
    matrix(1,0) = vector(2);
    matrix(1,2) = -vector(0);
    matrix(2,0) = -vector(2);
    matrix(2,1) = vector(0);

    return matrix

def vee_map(matrix):
    """Linear map from so(3) to R^3

    Inputs:
        - matrix - 3x3 numpy array

    Outputs:
        - vector - 3x1 numpy array
    """

    x1 = matrix(2,1)-matrix(1,2);
    x2 = matrix(0,2) - matrix(2,0);
    x3 = matrix(1,0)-matrix(0,1);

    vector = 1.0/2*[x1;x2;x3];

    return vector