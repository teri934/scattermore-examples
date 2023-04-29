import numpy as np, pandas as pd
from scipy.integrate import odeint

sigma = 10
rho = 28
beta = 8.0/3
theta = 3 * np.pi / 4

def lorenz(xyz, t):
    x, y, z = xyz
    x_dot = sigma * (y - x)
    y_dot = x * rho - x * z - y
    z_dot = x * y - beta* z
    return [x_dot, y_dot, z_dot]

initial = (-10, -7, 35)
t = np.arange(0, 10000, 0.006)

solution = odeint(lorenz, initial, t)

pd.DataFrame(solution).to_csv('lorenz.csv', index=None)
