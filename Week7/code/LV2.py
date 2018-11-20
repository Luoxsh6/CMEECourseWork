# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

""" The typical Lotka-Volterra Model with prey density dependence simulated using scipy, Take arguments from the command line"""

import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys
import matplotlib.backends.backend_pdf

def dCR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any given time step"""

    R = pops[0]
    C = pops[1]
    dRdt = r*R*(1 - R/K) - a*R*C
    dCdt = -z*C + e*a*R*C

    return sc.array([dRdt, dCdt])


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
    z = 1.5
    e = 0.75
    K = 5000

# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 15,  1000)

R0 = 10
C0 = 5
# initials conditions: 10 prey and 5 predators per unit area
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

print(infodict['message'])     # >>> 'Integration successful.'


f1 = p.figure()  # Open empty figure object
p.plot(t, pops[:, 0], 'g-', label='Resource density')  # Plot
p.plot(t, pops[:, 1], 'b-', label='Consumer density')
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
p.plot(pops[:, 0], pops[:, 1], 'r-', label='Consumer density')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')
p.figtext(.79, .58, " r =" + str(r) + "\n a =" + str(a) + "\n z = " + str(z)
          + "\n e = " + str(e) + "\n K = " + str(K))
# p.show()  # To display the figure

# Save both figures into a single pdf
pdf = matplotlib.backends.backend_pdf.PdfPages('../results/LV_model2.pdf')
pdf.savefig(f1)
pdf.savefig(f2)
pdf.close()
p.close('all')