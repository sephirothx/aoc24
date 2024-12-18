from queue import PriorityQueue

with open("input.txt") as f:
    inp = f.read().strip().splitlines()
pixels = [tuple(map(int, line.split(','))) for line in inp]

exit = (70, 70)
dirs = [(0,1), (1,0), (0,-1), (-1,0)]

def get_neighbors(i, j):
    n = []
    for d in dirs:
        ii, jj = i + d[0], j+ d[1]
        if 0 <= ii <= exit[0] and 0 <= jj <= exit[1]:
            n.append((ii, jj))
    return n

def shortest_path(start, end, pix):
    q = PriorityQueue()
    visited = set()
    q.put((0, start))
    while not q.empty():
        dist, pos = q.get()
        if pos in visited:
            continue
        visited.add(pos)
        if pos == end:
            return dist
        for n in get_neighbors(*pos):
            if n not in pix:
                q.put((dist+1, n))

print(shortest_path((0,0), exit, set(pixels[:1024])))

lo, hi = 1024, len(pixels) - 1
while lo < hi:
    mid = (lo + hi) // 2
    if shortest_path((0, 0), exit, set(pixels[:mid])) != None:
        lo = mid + 1
    else:
        hi = mid - 1
print(pixels[hi - 1])
