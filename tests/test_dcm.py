import rot.dcm as dcm
import unittest
import numpy as np 
import numpy.testing as npt

class DCMTestCase(unittest.TestCase):
    """Tests for dcm.py"""
    vec = np.random.random(3)

    def setUp(self):
        pass

    def test_is_hat_map_skew_sym(self):
        """Is hat_map skew-symmetric?"""

        
        mat = dcm.hat_map(DCMTestCase.vec)

        npt.assert_allclose(np.transpose(mat),-mat)

    def test_hat_and_vee_map(self):
        """Is the vee_map(hat_map(vec)) = vec?"""

        vec = DCMTestCase.vec

        npt.assert_allclose(dcm.vee_map(dcm.hat_map(vec)),vec)

if __name__ == '__main__':
    unittest.main()