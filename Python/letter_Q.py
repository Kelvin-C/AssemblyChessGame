# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
no_of_intervals = 0.1/2.5*255.

"""
#Plot square grid
y01 = np.linspace(0, 0.21, 4) 
x01 = np.zeros(len(y01))
y01 = y01[::-1]

x02 = np.linspace(0, 0.21, 4) 
y02 = np.zeros(len(x02))

y03 = np.linspace(0, 0.21, 4) 
x03 = np.zeros(len(y03))


x04 = np.linspace(0, 0.21, 4) 
y04 = np.zeros(len(x04))
x04 = x04[::-1]

x0_lst = [x01,x02,x03,x04]
y0_lst = [y01,y02,y03,y04]

x0s = []
y0s = []

x0_lst = [x01,x02,x03,x04]
y0_lst = [y01,y02,y03,y04]

x0s = []
y0s = []

for x in x0_lst:
    for j in np.arange(len(x)):
        x0s += [x[j]]
        
for y in y0_lst:
    for j in np.arange(len(y)):
        y0s += [y[j]]

x0s = np.array(x0s)
y0s = np.array(y0s)

x0s = x0s - 0.1
y0s = y0s - 0.1

#plt.plot(xs, ys)

x0s_volt = (x0s+1.25)/2.5*255
y0s_volt = (y0s+1.25)/2.5*255

plt.figure(2)
plt.plot(x0s_volt, y0s_volt)
"""


print no_of_intervals
#flipped xy
#y1 = np.arange(0, 0.051, 0.02) 
y1 = np.linspace(0, 0.11, 2) *0.75
x1 = np.zeros(len(y1)) 
y1 = y1[::-1]

x2 = np.linspace(0, 0.051, 2) 
y2 = np.zeros(len(x2))

y3 = np.linspace(0, 0.11, 2) *0.75
x3 = np.array([0.051]*len(y3))


x4 = np.linspace(0, 0.051, 2)  
y4 = np.array([0.11]*len(x4)) *0.75
x4 = x4[::-1]

x5 = np.linspace(0.051/2, -0.051/2,4)
y5 = np.linspace(0.11*3/4, 0.11 + 0.11/4,4) *0.75
"""
x5 = np.linspace(-0.051/2 *0.75, 0,2) 
y5 = np.linspace(0.11, 0.11+ 0.11/4*0.75, 2) *0.75
x5 = x5[::-1]

x6 = np.linspace(-0.051/2 *0.75, 0.051/2,2)
y6 = np.linspace(0.11+ 0.11/4*0.75, 0.11- 0.11/4, 2) *0.75 

x7 = np.linspace(0.051/2, 0,2) 
y7 = np.linspace(0.11 - 0.11/4, 0.11 , 2) *0.75
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