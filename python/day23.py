import networkx as nx

with open("input.txt") as f:
    inp = f.read().strip().splitlines()

G = nx.Graph()
G.add_edges_from(line.split('-') for line in inp)

cliques3 = [c for c in nx.enumerate_all_cliques(G) if len(c) == 3]
cliques3_with_t = [c for c in cliques3 if any(node.startswith('t') for node in c)]
print(len(cliques3_with_t))

max_clique = max(nx.find_cliques(G), key=len)
print(','.join(sorted(max_clique)))
