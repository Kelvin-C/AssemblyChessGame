# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
no_of_intervals = 0.1/2.5*255.

print no_of_intervals
#flipped xy
#y1 = np.arange(0, 0.051, 0.02) 
y1 = np.linspace(0, 0.11, 4) 
x1 = np.array([0.051]*len(y1))
x1 = x1[::-1]


x2 = np.linspace(0, 0.051, 3) 
y2 = np.zeros(len(x2))
x2 = x2[::-1]


y3 = np.linspace(0, 0.051, 3)
x3 = np.zeros(len(y3)) 


x4 = np.linspace(0, 0.051, 3) 
y4 = np.array([0.051]*len(x4))

x5 = np.linspace(0, 0.051, 3)
y5 = np.linspace(0.051, 0.11, 3)
x5 = x5[::-1]
"""
x2 = np.arange(0, 0.051, 0.01) 
y2 = np.arange(0.05, 0.11, 0.01)
x2 = x2[::-1]

x3 = np.arange(0, 0.051, 0.01) 
y3 = np.arange(0, 0.051, 0.01)
x3 = x3[::-1]
y3 = y3[::-1]
"""



x_lst = [x1,x2,x3,x4,x5]
y_lst = [y1,y2,y3,y4,y5]

xs = []
ys = []
for x in x_lst:
    for j in np.arange(len(x)):
        xs += [x[j]]
        
for y in y_lst:
    for j in np.arange(len(y)):
        ys += [y[j]]

xs = np.array(xs)
ys = np.array(ys)

"""
plt.figure(1)
plt.plot(xs, ys)
plt.xlim([-0.1,0.1])
plt.ylim([-0.1,0.1])
"""
#shift to centre of grid
xs = xs - 0.025
ys = ys - 0.05
#plt.plot(xs, ys)


xs_volt = (xs+1.25)/2.5*255
ys_volt = (ys+1.25)/2.5*255

plt.figure(2)
plt.plot(xs_volt, ys_volt) #before round off
xs_volt = np.round(xs_volt)
ys_volt = np.round(ys_volt)
xs_volt = [int(x) for x in xs_volt]
ys_volt = [int(x) for x in ys_volt]
xs_volt = list(xs_volt)
ys_volt = list(ys_volt)

lstt =[]
for i in np.arange(len(xs_volt)):
    lstt +=[xs_volt[i]]
    lstt +=[ys_volt[i]]
lstt = lstt[::-1] #flip
print lstt #output list with alternate x and y voltages
print "len(lstt):", len(lstt)
plt.plot(xs_volt, ys_volt) #after round off
plt.xlim([117.5, 137.5])
plt.ylim([117.5, 137.5])
plt.show()