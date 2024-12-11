with open("input.txt") as f:
    inp = list(map(int, f.read().strip().split()))

def split(rock):
    if rock == 0:
        return [1]
    if (l := len(s := str(rock))) % 2 == 0:
        return [int(s[:l//2]), int(s[l//2:])]
    return [rock*2024]

cache = {}
def split_many_times(rock, n):
    if n == 0:
        return 1
    if (rock, n) not in cache:
        cache[(rock, n)] = sum(split_many_times(r, n-1) for r in split(rock))
    return cache[(rock, n)]

def blink_dp(rocks, n):
    return sum(split_many_times(r, n) for r in rocks)

from collections import Counter
def blink_iter(rocks, n):
    counts = Counter(rocks)
    for _ in range(n):
        new_counts = Counter()
        for r, c in counts.items():
            for nr in split(r):
                new_counts[nr] += c
        counts = new_counts
    return sum(counts.values())

# blink = blink_dp
blink = blink_iter
print(blink(inp, 25))
print(blink(inp, 75))
