from __future__ import absolute_import, division, print_function
from mayavi import mlab
import numpy as np

alpha = np.linspace(0, 2*np.pi, 100)
xs = np.cos(alpha)
ys = np.sin(alpha)
zs = np.zeros_like(xs)

mlab.points3d(0, 0)
plt = mlab.points3d(xs[:1], ys[:1], zs[:1])

@mlab.animate(delay=100)

def anim():
    from
