with open("input.txt") as f:
    inp = f.read().split("\n\n")

edges = [tuple(map(int, line.split('|'))) for line in inp[0].split('\n')]
lists = [list(map(int, line.split(','))) for line in inp[1].split('\n')]

def is_ordered(l, edges):
    d = {item: index for index, item in enumerate(l)}
    ordered = True
    for n1, n2 in edges:
        if n1 in d and n2 in d and d[n1] > d[n2]:
            l[d[n1]], l[d[n2]] = l[d[n2]], l[d[n1]]
            d[n1], d[n2] = d[n2], d[n1]
            ordered = False
    return ordered

part1, part2 = 0, 0
for l in lists:
    ok = True
    while not is_ordered(l, edges):
        ok = False
    mid = l[len(l)//2]
    part1 += mid if ok else 0
    part2 += mid if not ok else 0

print(part1, part2)
