from collections import defaultdict
from itertools import combinations

with open("input.txt") as f:
    inp = [line.strip() for line in f]

size = (len(inp), len(inp[0]))

ant = defaultdict(list)
for i, l in enumerate(inp):
    for j, c in enumerate(l):
        if c != '.':
            ant[c].append((i,j))

def find_antinodes(ant, start, end):
    antis = set()
    for _, nodes in ant.items():
        for a1, a2 in combinations(nodes, 2):
            dx, dy = a2[0] - a1[0], a2[1] - a1[1]
            anti = []
            for i in range(start, end):
                anti.append((a1[0] - dx*i, a1[1] - dy*i))
                anti.append((a2[0] + dx*i, a2[1] + dy*i))
            for a in anti:
                if 0<=a[0]<size[0] and 0<=a[1]<size[1]:
                    antis.add(a)
    return antis

print(len(find_antinodes(ant, 1, 2)))
print(len(find_antinodes(ant, 0, 100)))
