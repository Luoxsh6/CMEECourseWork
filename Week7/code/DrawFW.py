#!/usr/bin/env python3

""" Plotting a food web network with synthetic data """

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

import networkx as nx
import scipy as sc
import matplotlib.pyplot as p


def GenRdmAdjList(N = 2, C = 0.5):
    """ Generate a random adjacency list, with consumer and resource ID pairs"""
    Ids = range(N) 
    ALst = []
    for i in Ids:
        if sc.random.uniform(0,1,1) < C:  # If connectance is higher than random ones, then there is a link between species 
            Lnk = sc.random.choice(Ids,2).tolist() # Generate a random sample with 2 species, and convert to list
            if Lnk[0] != Lnk[1]: #avoid self (e.g., cannibalistic) loops
                ALst.append(Lnk)  
    return ALst


# Assign parameters
MaxN = 30 # Number of species
C = 0.75  # Connectance

# Generate species data
AdjL = sc.array(GenRdmAdjList(MaxN, C))
print(AdjL)
Sps = sc.unique(AdjL)  # Get species ids
print(Sps)

# Gnerate species body size data
SizRan = ([-10, 10]) # Use log10 scale
Sizs = sc.random.uniform(SizRan[0], SizRan[1], MaxN) # Randomly distributed node size
print(Sizs)

# Plot histogram of body size
p.hist(Sizs) # log10 scale 
p.hist(10 ** Sizs) # raw scale
p.close('all') # close all open plot objects

pos = nx.circular_layout(Sps) # Take species data and plot in circular layout

# Create a network graph object
G = nx.Graph() #

# Add nodes and links
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL)) # this function needs a tuple input

# Generate node sizes proportional to log body sizes
NodSizs= 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs))

# Plots the graph and saves to pdf
f = p.figure()
nx.draw_networkx(G, pos, node_size = NodSizs)
f.savefig(r'../results/Food_network.pdf')
p.close('all')