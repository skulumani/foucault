""" Test the pendulum dynamics

"""
import numpy as np
import dynamics

class TestDynamics():
    pend = dynamics.Pendulum(Omega=7.2921158553e-5, L=100, m=100, beta=40*np.pi/180)
    time = np.linspace(0, 10, 100)
    initial_state = np.hstack((np.array([1, 0, 0]), np.array([0, 1, 0])))

    def test_nl_odeint_size(self):
        state_dot = self.pend.nl_odeint(self.initial_state, 1)

        np.testing.assert_equal(state_dot.shape, (6,))
        
    def test_len_odeint_size(self):
        state_dot = self.pend.len_odeint(self.initial_state, 1)

        np.testing.assert_equal(state_dot.shape, (6, ))
    
    def test_nl_ode_size(self):
        state_dot = self.pend.nl_ode(1, self.initial_state)

        np.testing.assert_equal(state_dot.shape, (6,))
        
    def test_len_ode_size(self):
        state_dot = self.pend.len_ode(1, self.initial_state)

        np.testing.assert_equal(state_dot.shape, (6, ))
    
    def test_nl_ode_output(self):
        pass
