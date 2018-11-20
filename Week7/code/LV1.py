# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

""" The typical Lotka-Volterra Model simulated using scipy """

import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
import matplotlib.backends.backend_pdf

def dCR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any given time step"""

    R = pops[0]
    C = pops[1]
    dRdt = r*R - a*R*C
    dCdt = -z*C + e*a*R*C

    return sc.array([dRdt, dCdt])


# Define parameters:
r = 1.  # Resource growth rate
a = 0.1  # Consumer search rate (determines consumption rate)
z = 1.5  # Consumer mortality rate
e = 0.75  # Consumer production efficiency

# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 15,  1000)

R0 = 10
C0 = 5
# initials conditions: 10 prey and 5 predators per unit area
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

print(infodict['message'])     # >>> 'Integration successful.'



# Plot population density against time using matplotlib.pylab
f1 = p.figure()  # Open empty figure object
p.plot(t, pops[:, 0], 'g-', label='Resource density')  # Plot
p.plot(t, pops[:, 1], 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
# p.show()  # To display the figure


f2 = p.figure()
p.plot(pops[:, 0], pops[:, 1], 'r-', label='Consumer density')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')
# p.show()  # To display the figure

# Save both figures into a single pdf
pdf = matplotlib.backends.backend_pdf.PdfPages('../results/LV_model1.pdf')
pdf.savefig(f1)
pdf.savefig(f2)
pdf.close()
p.close('all')