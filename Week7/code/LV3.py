# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

""" The typical Lotka-Volterra Model simulated using scipy,
with appropriate parameters """


import scipy as sc
import scipy.integrate as integrate
import pylab as p  # Contains matplotlib for plotting
import sys


def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any given time step """

    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R / K) - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])


r = .5  # Resource growth rate
a = 0.1  # Consumer search rate (determines consumption rate)
z = 1.5  # Consumer mortality rate
e = .75  # Consumer production efficiency
K = 27  # Carrying capacity


# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 40,  1000)


R0 = 10
C0 = 5
# initials conditions: 10 prey and 5 predators per unit area
CR0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dR_dt, CR0, t, full_output=True)

print(infodict['message'])     # >>> 'Integration successful.'

f1 = p.figure()  # Open empty figure object
p.plot(t, pops[:, 0], 'g-', label='Resource density')  # Plot
p.plot(t, pops[:, 1], 'b-', label='Consumer density')
p.grid()
p.figtext(.8, .5, " r =" + str(r) + "\n a =" + str(a) + "\n z = " + str(z)
          + "\n e = " + str(e) + "\n K = " + str(K))

p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population')
p.title('Consumer-Resource population dynamics')
p.show()

f1.savefig('../results/LV_model3.pdf')  # Save figure
prey = list(pops.T[1])
pred = list(pops.T[0])

print("The preys final population density is: {0:.2f} and the final predators population: {1:.2f}".format(
    prey[-1], pred[-1]))
