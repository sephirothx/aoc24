with open("input.txt") as f:
    inp = f.read().strip().split("\n\n")

locks = []
keys = []
for p in inp:
    tmp = [0] * 5
    for line in p.splitlines():
        for j, c in enumerate(line):
            if c == "#":
                tmp[j] += 1
    if p[0] == '#':
        locks.append(tmp)
    else:
        keys.append(tmp)

sol = len(keys) * len(locks)
for l in locks:
    for k in keys:
        for i in range(len(l)):
            if l[i] + k[i] > 7:
                sol -= 1
                break
print(sol)
