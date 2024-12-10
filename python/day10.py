with open("input.txt") as f:
    inp = [line.strip() for line in f]

size = (len(inp), len(inp[0]))
dirs = [(0,1), (1,0), (0,-1), (-1,0)]

def get_neighbors(i, j):
    n = []
    for d in dirs:
        ii, jj = i + d[0], j+ d[1]
        if 0 <= ii < size[0] and 0 <= jj < size[1]:
            n.append((ii, jj))
    return n

def trail_score(i, j, next):
    h = int(inp[i][j])
    if h != next:
        return 0
    if h == 9:
        return 1
    return sum(trail_score(ni, nj, h + 1) for ni, nj in get_neighbors(i, j))

def trail_score_no_repeat(i, j, next, visited):
    h = int(inp[i][j])
    if h != next or (i, j) in visited:
        return 0
    if h == 9:
        visited.add((i, j))
        return 1
    return sum(trail_score_no_repeat(ni, nj, h + 1, visited) for ni, nj in get_neighbors(i, j))

part1 = sum(trail_score_no_repeat(i, j, 0, set()) for i in range(size[0]) for j in range(size[1]))
part2 = sum(trail_score(i, j, 0) for i in range(size[0]) for j in range(size[1]))

print(part1)
print(part2)
