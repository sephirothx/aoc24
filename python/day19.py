from functools import lru_cache

with open("input.txt") as f:
    patterns, towels = f.read().strip().split("\n\n")
patterns = patterns.split(", ")
towels = towels.splitlines()

@lru_cache()
def is_possible(towel: str, i=0):
    if i == len(towel):
        return True
    return any(is_possible(towel, i+len(pattern)) for pattern in patterns if towel[i:].startswith(pattern))

@lru_cache()
def ways(towel: str, i=0):
    if i == len(towel):
        return 1
    return sum(ways(towel, i+len(pattern)) for pattern in patterns if towel[i:].startswith(pattern))

print(sum(1 for t in towels if is_possible(t)))
print(sum(ways(t) for t in towels if is_possible(t)))
