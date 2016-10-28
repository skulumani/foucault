from context import euler_rot 
import unittest
import numpy as np 
import numpy.testing as npt

class EulerTestCase(unittest.TestCase):
    """Tests for `euler_rot.py`."""
    angle = (2*np.pi - 0) * np.random.random() + 0.0

    def setUp(self):
        pass

    def test_is_rot_orthogonal(self):
        """Is R^T = R?"""

        angle = EulerTestCase.angle
        
        npt.assert_allclose(np.dot(euler_rot.ROT1(angle),np.transpose(euler_rot.ROT1(angle))) ,np.eye(3,3))
        npt.assert_allclose(np.dot(euler_rot.ROT2(angle),np.transpose(euler_rot.ROT2(angle))) ,np.eye(3,3))
        npt.assert_allclose(np.dot(euler_rot.ROT3(angle),np.transpose(euler_rot.ROT3(angle))) ,np.eye(3,3))

    def test_is_det_one(self):
        """Is det(R)=1?"""

        angle = EulerTestCase.angle

        npt.assert_allclose(np.linalg.det(euler_rot.ROT1(angle)), 1.0)
        npt.assert_allclose(np.linalg.det(euler_rot.ROT2(angle)), 1.0)
        npt.assert_allclose(np.linalg.det(euler_rot.ROT3(angle)), 1.0)

if __name__ == '__main__':
    unittest.main()