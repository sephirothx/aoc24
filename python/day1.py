with open("./input.txt") as f:
    l1, l2 = zip(*(map(int, line.split()) for line in f))

part1 = sum(abs(n1 - n2) for n1, n2 in zip(sorted(l1), sorted(l2)))
print(part1)

from collections import Counter

l2_counts = Counter(l2)
part2 = sum(n1 * l2_counts[n1] for n1 in l1)
print(part2)
