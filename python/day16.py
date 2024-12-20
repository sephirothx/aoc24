import math
from input import get_all_positions_of
from geometry import *
from pathfinding import dijkstra

with open("input.txt") as f:
    inp = f.read().strip().splitlines()

S = get_all_positions_of('S', inp)[0]
E = get_all_positions_of('E', inp)[0]
D = dir_map['>']
walls = get_all_positions_of('#', inp)
size = (len(inp), len(inp[0]))

def gn(elem):
    pos, dir = elem
    output = []
    next_pos = add(pos, dir)
    if next_pos not in walls:
        output.append(((next_pos, dir), 1))
    output.append(((pos, turn_left(dir)), 1000))
    output.append(((pos, turn_right(dir)), 1000))
    return output

part1, _, D1 = dijkstra((S, D), (E, dir_map['>']), gn)
print(part1)
_, _, D2 = dijkstra((E, dir_map['<']), (S, reverse(D)), gn)

print("DONE!")
seats = set()
for k, v in D1.items():
    pos, dir = k
    other = (pos, reverse(dir))
    if other in D2 and D2[other] + v == part1:
        seats.add(pos)

print(len(seats))
