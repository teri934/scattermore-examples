import numpy as np, pandas as pd
from numba import jit
from math import sin, cos, sqrt, fabs

@jit(nopython=True)
def Clifford(x, y, a, b, c, d, *o):
    return sin(a * y) + c * cos(a * x), \
           sin(b * x) + d * cos(b * y)
           
@jit(nopython=True)
def Svensson(x, y, a, b, c, d, *o):
    return d * sin(a * x) - sin(b * y), \
           c * cos(a * x) + cos(b * y)
           
@jit(nopython=True)
def Hopalong2(x, y, a, b, c, *o):
    return y - 1.0 - sqrt(fabs(b * x - 1.0 - c)) * np.sign(x - 1.0), \
           a - x - 1.0

@jit(nopython=True)
def Symmetric_Icon(x, y, a, b, g, om, l, d, *o):
    zzbar = x*x + y*y
    p = a*zzbar + l
    zreal, zimag = x, y
    
    for i in range(1, d-1):
        za, zb = zreal * x - zimag * y, zimag * x + zreal * y
        zreal, zimag = za, zb
    
    zn = x*zreal - y*zimag
    p += b*zn
    
    return p*x + g*zreal - om*y, \
           p*y - g*zimag + om*x

n=10000000

@jit(nopython=True)
def trajectory_coords(fn, x0, y0, a, b=0, c=0, d=0, e=0, f=0, n=n):
    x, y = np.zeros(n), np.zeros(n)
    x[0], y[0] = x0, y0
    for i in np.arange(n-1):
        x[i+1], y[i+1] = fn(x[i], y[i], a, b, c, d, e, f)
    return x,y

def trajectory(fn, x0, y0, a, b=0, c=0, d=0, e=0, f=0, n=n):
    x, y = trajectory_coords(fn, x0, y0, a, b, c, d, e, f, n)
    return pd.DataFrame(dict(x=x,y=y))
	
	
df = trajectory(Clifford, 0, 0, -1.3, -1.3, -1.8, -1.9)
df.to_csv(r'C:\Users\kulic\Desktop\data_images\clifford.csv', index=False)

df = trajectory(Svensson, 0, 0, 1.4, 1.56, 1.4, -6.56)
df.to_csv(r'C:\Users\kulic\Desktop\data_images\svensson.csv', index=False)

df = trajectory(Hopalong2, 0, 0, 7.8, 0.13, 8.15)
df.to_csv(r'C:\Users\kulic\Desktop\data_images\hopalong2.csv', index=False)

df = trajectory(Symmetric_Icon, 0.01, 0.01, 10.0, -12.0, 1.0, 0.0, -2.195, 3)
df.to_csv(r'C:\Users\kulic\Desktop\data_images\symmetric_icon.csv', index=False)