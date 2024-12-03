with open("./input.txt") as f:
    reports = [list(map(int, line.split())) for line in f]

def is_safe(r):
    return all(0<j-i<4 for i, j in zip(r, r[1:])) or all(0<i-j<4 for i, j in zip(r, r[1:]))

part1 = sum(map(is_safe, reports))
print(part1)

part2 = sum(1 for r in reports if is_safe(r) or any(is_safe(r[:i] + r[i+1:]) for i in range(len(r))))
print(part2)
