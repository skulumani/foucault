""" Test the pendulum dynamics

"""
import numpy as np
import dynamics

class TestDynamics():
    pend = dynamics.Pendulum()
    time = np.linspace(0, 10, 100)
    initial_state = np.hstack((np.array([1, 0, 0]), np.random.rand(3)))

    def test_nl_ode_size(self):
        state_dot = self.pend.nl_ode(self.initial_state, 1)

        np.testing.assert_equal(state_dot.shape, (6,))
        
    def test_len_ode_size(self):
        state_dot = self.pend.len_ode(self.initial_state, 1)

        np.testing.assert_equal(state_dot.shape, (6, ))

