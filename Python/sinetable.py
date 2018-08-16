import numpy as np

N = 25
a = np.arange(0,N)
sine = np.sin(2*np.pi*a/N)

output = (sine+1)*255/2
final = []
for i in range(len(output)):
    final += [int(output[i])]    
    
print final