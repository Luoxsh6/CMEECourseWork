# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

""" The discrete-time version of Lotka-Volterra Model simulated using scipy, with appropriate parameters and e """


import scipy as sc
import scipy.stats as stats
import pylab as p  # Contains matplotlib for plotting
import sys
import matplotlib.backends.backend_pdf

def dCR_dt(RC0, t=0):
    """ Returns the growth rate of predator and prey populations at any given time step """   
    RC = sc.zeros((t,2))  #pre-allocate
    RC[0,0] = RC0[0]
    RC[0,1] = RC0[1]
    for i in range(t-1):
        RC[i+1,0] = RC[i,0] * (1 + (r + stats.norm.rvs(0, 0.1)) * (1 - RC[i,0] / K) - a * RC[i,1])
        RC[i+1,1] = RC[i,1] * (1 - z + stats.norm.rvs(0, 0.1) + e * a * RC[i,0])

    return RC


# Define parameters:
if len(sys.argv) == 6:
    r = float(sys.argv[1])  # Resource growth rate
    a = float(sys.argv[2])  # Consumer search rate (determines consumption rate)
    z = float(sys.argv[3])  # Consumer mortality rate
    e = float(sys.argv[4])  # Consumer production efficiency
    K = float(sys.argv[5])  # Carrying capacity
else:
    r = 1.
    a = 0.1
    z = 0.4
    e = 0.75
    K = 100


# Now define time 
t = 13


R0 = 10
C0 = 5
# initials conditions: 10 prey and 5 predators per unit area
RC0 = sc.array([R0, C0])
RC = dCR_dt(RC0, t)
print("After %s years, the consumer density is %s, the resource density is %s" %(t-1, RC[t-1,1], RC[t-1,0]))


f1 = p.figure()  # Open empty figure object
p.plot(range(t), RC[:, 0], 'g-', label='Resource density')  # Plot
p.plot(range(t), RC[:, 1], 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.figtext(.79, .58, " r =" + str(r) + "\n a =" + str(a) + "\n z = " + str(z)
          + "\n e = " + str(e) + "\n K = " + str(K))
# p.show()  # To display the figure


# Plot consumer density against resource density
f2 = p.figure()
p.plot(RC[:, 0], RC[:, 1], 'r-', label='Consumer density')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')
p.figtext(.79, .58, " r =" + str(r) + "\n a =" + str(a) + "\n z = " + str(z)
          + "\n e = " + str(e) + "\n K = " + str(K))
# p.show()  # To display the figure

# Save both figures into a single pdf
pdf = matplotlib.backends.backend_pdf.PdfPages('../results/LV_model4.pdf')
pdf.savefig(f1)
pdf.savefig(f2)
pdf.close()
p.close('all')