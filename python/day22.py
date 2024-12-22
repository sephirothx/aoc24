from collections import defaultdict
from input import get_all_ints
import time

with open("input.txt") as f:
    inp = get_all_ints(f.read())

ops = [
    lambda x: x*64,
    lambda x: x//32,
    lambda x: x*2048,
]

def next_secret(secret: int):
    out = secret
    for op in ops:
        v = op(out)
        out ^= v
        out %= 16777216
    return out

ITERATIONS = 2000
MONKEYS = len(inp)
price = [[0 for _ in range(ITERATIONS)] for _ in range(MONKEYS)]
diff = [[0 for _ in range(ITERATIONS)] for _ in range(MONKEYS)]
for iteration in range(ITERATIONS):
    for monkey, secret in enumerate(inp):
        new_secret = next_secret(secret)
        price[monkey][iteration] = new_secret % 10
        diff[monkey][iteration] = (new_secret % 10) - (secret % 10)
        inp[monkey] = new_secret

sell_prices = defaultdict(lambda: [None] * MONKEYS)
for iteration in range(ITERATIONS - 3):
    for monkey in range(MONKEYS):
        key = (diff[monkey][iteration], diff[monkey][iteration + 1], diff[monkey][iteration + 2], diff[monkey][iteration + 3])
        if sell_prices[key][monkey] == None:
            sell_prices[key][monkey] = price[monkey][iteration + 3]

part2 = 0
for k, v in sell_prices.items():
    tot = 0
    for n in v:
        if n != None:
            tot += n
    part2 = max(part2, tot)

print(sum(inp))
print(part2)
