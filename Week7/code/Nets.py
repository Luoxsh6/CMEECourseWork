#!/usr/bin/python

""" Python script for visualising a network of QMEE CDT collaborators."""

# Import necessary modules
import csv
import networkx as nx
import scipy as sc
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches


# Collecting/generating info on the edges of the network.
# Opens the csv file containing edge information.
link_info = sc.genfromtxt("../data/QMEE_Net_Mat_edges.csv", delimiter=",")

# Removes the location names from the array/extracts info on interactions.
links = link_info[1:, :]

# Identifies the presence of links between collaborating sites and creates an array of these links
adjacency = sc.argwhere(links > 1.)

# ~ weighted = ()
# ~ for i in adjacency:
# ~ weighted = weighted + ((i[0], i[1], (links[i[0], i[1]])),)

# Creates a tuple of connections between sites using the adjacency array.
connect = ()
for i in adjacency:
    connect = connect + ((i[0], i[1]),)

# Creates a list of link weights using the links array.
weights = []
for i in adjacency:
    weights.append((links[i[0], i[1]])/10)


# Collecting/generating info on the nodes in the network.
# Opens the csv file containing the node information.
node_info = sc.genfromtxt(
    "../data/QMEE_Net_Mat_nodes.csv", delimiter=",", dtype=None)

# Extracts the institution names from the node data.
nodes = node_info[1:, 0]

# Creates the variable NodSizs to make the size of the nodes in the network proportional to the number of PIs at the institution.
NodSizs = []
for i in node_info[1:, 2]:
    NodSizs.append(float(i)*100)

# Label nodes
names = {}
for i in range(len(nodes)):
    names[i] = nodes[i]

# Assign colours for node type
colours = []
for i in node_info[1:, 1]:
    if i == 'University':
        colours.append('b')
    if i == 'Hosting Partner':
        colours.append('g')
    if i == 'Non-Hosting Partners':
        colours.append('r')

# Create items for the legend
blue_patch = mpatches.Patch(color='blue', label='University')
green_patch = mpatches.Patch(color='green', label='Hosting Partner')
red_patch = mpatches.Patch(color='red', label='Non-Hosting Partner')


# Drawng the network.
# Plot graph
plt.close('all')
G = nx.Graph()

# Creates a position variable causing the nodes to be arranged in a circle.
pos = nx.circular_layout(range(len(nodes)))

# Draws the network uing the above objects
nx.draw_networkx(G, pos,
                 nodelist=range(len(nodes)),
                 node_color=colours,
                 labels=names,
                 font_size='13',
                 node_size=NodSizs*1000,
                 edgelist=connect,
                 width=weights)
# Removes the axes
plt.axis('off')

# Plots a legend to indicate the colour coding
plt.legend(handles=[blue_patch, green_patch, red_patch], loc=2, fontsize=10)

# Saves the plot.
plt.savefig('../results/Nets_plot.svg')
