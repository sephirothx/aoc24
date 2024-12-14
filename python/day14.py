from functools import reduce
from operator import mul
import re

w, h = 101, 103

with open("input.txt") as f:
    robots = [[int(x) for x in re.findall("-?\d+", line)] for line in f]

def move(r):
    x, y, vx, vy = r
    r[:2] = (x + vx) % w, (y + vy) % h

q = [0] * 4
mid_x, mid_y = w // 2, h // 2

for r in robots:
    for _ in range(100):
        move(r)
    x, y = r[:2]
    if x != mid_x and y != mid_y:
        i = x // (mid_x + 1) + 2 * (y // (mid_y + 1))
        q[i] += 1

print(reduce(mul, q, 1))
