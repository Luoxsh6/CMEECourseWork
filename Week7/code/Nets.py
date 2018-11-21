# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

"""Visualizes the QMEE CDT collaboration network"""

import networkx as nx
import csv
import matplotlib.pyplot as p
import numpy as np
import pandas as pd
import scipy as sc

# loading data
links = pd.read_csv("../data/QMEE_Net_Mat_edges.csv")
nodes = pd.read_csv("../data/QMEE_Net_Mat_nodes.csv")


links["id"] = links.columns  # add row names to links
linkmelt = pd.melt(links, id_vars=["id"])  # melt link to 'id'
linkmelt = linkmelt[~linkmelt['value'].isin([0])]  # delete value = 0

edges = linkmelt.apply(tuple, axis=1)  # make tuple

# print(edges)
# print(nodes)

pos = nx.circular_layout(nodes["id"])  # Creating a circular network

G = nx.DiGraph()  # generate a networkx graph object
G.add_nodes_from(nodes["id"])  # add nodes

for (u, v, w) in edges:  # add edges
    G.add_edge(u, v, weight=w)

#  plot and save as svg
f = p.figure()
nx.draw_networkx(G, pos, node_size=900)
f.savefig(r'../results/QMEENetpy.svg')
p.close('all')


# edge_labels = dict([((u, v), d["weight"]) for u, v, d in G.edges(data=True)])

# nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

# G = nx.relabel_nodes(G, nodes["id"])
# print(G["ICL"]["CEH"]["weight"])
