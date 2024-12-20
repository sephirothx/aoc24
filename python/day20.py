from input import get_all_positions_of
from geometry import *
from pathfinding import dijkstra
import time

with open("input.txt") as f:
    inp = f.read().strip().splitlines()

S = get_all_positions_of('S', inp)[0]
E = get_all_positions_of('E', inp)[0]
walls = set(get_all_positions_of('#', inp))

def gn(pos):
    return [(n, 1) for n in get_neighbors(pos) if n not in walls]

normal_time,_,DS = dijkstra(S, E, gn)
print(normal_time)
_,_,DE = dijkstra(E, S, gn)

def shortest_path_with_cheat(cheat, delta=100):
    output = 0
    for p1 in DS:
        p1x, p1y = p1
        for x in range(p1x - cheat, p1x + cheat + 1):
            for y in range(p1y - cheat, p1y + cheat + 1):
                if (x, y) in DE and (d := manhattan_distance(p1, (x, y))) <= cheat:
                    t = DS[p1] + DE[(x, y)] + d
                    if t <= normal_time - delta:
                        output += 1
    return output

start = time.time()
print(shortest_path_with_cheat(2))
end = time.time()
print("execution time =", end-start)

start = time.time()
print(shortest_path_with_cheat(20))
end = time.time()
print("execution time =", end-start)
