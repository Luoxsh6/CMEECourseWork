import networkx as nx
import scipy as sc
import matplotlib.pyplot as p

def GenRdmAdjList(N = 2, C = 0.5):
    """ 
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0,1,1) < C:
            Lnk = sc.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk[1]: #avoid self (e.g., cannibalistic) loops
                ALst.append(Lnk)
    return ALst


MaxN = 30
C = 0.75

AdjL = sc.array(GenRdmAdjList(MaxN, C))
AdjL



Sps = sc.unique(AdjL) # get species ids

SizRan = ([-10,10]) #use log10 scale
Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)
Sizs

p.hist(Sizs) #log10 scale
p.close('all')

pos = nx.circular_layout(Sps)
G = nx.Graph()

G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL)) # this function needs a tuple input



NodSizs= 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs))

nx.draw_networkx(G, pos, node_size = NodSizs)

p.show()