with open("input.txt") as f:
    inp = f.read().strip().split()

size = (len(inp), len(inp[0]))
dirs = [(0,1), (1,0), (0,-1), (-1,0)]

visited = set()
def find_plot(i, j):
    stack = []
    sides = {}
    stack.append((i, j))
    t = inp[i][j]
    area, perimeter = 0, 0
    while stack:
        x, y = stack.pop()
        if (x, y) in visited:
            continue
        visited.add((x,y))
        area += 1
        for dx, dy in dirs:
            next_i, next_j = x + dx, y + dy
            if not 0<=next_i<size[0] or not 0<=next_j<size[1] or t != inp[next_i][next_j]:
                perimeter += 1
                p = (x, y, dx, dy)
                p1 = sides.get((x+dy, y+dx, dx, dy))
                p2 = sides.get((x-dy, y-dx, dx, dy))
                if p1 and p2:
                    for k in (k for k,v in sides.items() if v == p2):
                        sides[k] = p1
                    sides[p] = p1
                sides[p] = p1 or p2 or p
            else:
                stack.append((next_i, next_j))
    return (area, perimeter, len(set(sides.values())))

part1 = 0
part2 = 0
for i in range(size[0]):
    for j in range(size[1]):
        a, p, s = find_plot(i, j)
        part1 += a * p
        part2 += a * s

print(part1)
print(part2)
