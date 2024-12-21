from functools import lru_cache

ARROW_KEYPAD = {
    'A': (0, 2),
    '^': (0, 1),
    '<': (1, 0),
    'v': (1, 1),
    '>': (1, 2),
}

NUMERIC_KEYPAD = {
    '7': (0, 0),
    '8': (0, 1),
    '9': (0, 2),
    '4': (1, 0),
    '5': (1, 1),
    '6': (1, 2),
    '1': (2, 0),
    '2': (2, 1),
    '3': (2, 2),
    '0': (3, 1),
    'A': (3, 2),
}

def map_key_move(a: str, b: str, pad):
    if a == b:
        return ['']
    ax, ay = pad[a]
    bx, by = pad[b]
    dx = bx - ax
    dy = by - ay
    h1 = ('v' if dx > 0 else '^') * abs(dx)
    h2 = ('>' if dy > 0 else '<') * abs(dy)
    ret = []
    if h1 and (bx, ay) in pad.values():
        ret.append(h1+h2)
    if h2 and (ax, by) in pad.values():
        ret.append(h2+h1)
    return ret

def generate_sequences(s: str, prev: str = 'A'):
    if len(s) == 0:
        yield ''
        return
    c = s[0]
    for a in generate_sequences(s[1:], c):
        for b in map_key_move(prev, c, NUMERIC_KEYPAD):
            yield b + 'A' + a

@lru_cache()
def transf(s: str, depth: int):
    if depth == 0:
        return len(s)
    total = 0
    prev = 'A'
    for c in s:
        total += min(transf(v + 'A', depth-1) for v in map_key_move(prev, c, ARROW_KEYPAD))
        prev = c
    return total

def calculate_complexity(s: str, depth: int):
    n = int(s[:3])
    min_seq_len = min(transf(seq, depth) for seq in generate_sequences(s))
    return n * min_seq_len

def solve(input, depth):
    return sum(calculate_complexity(line, depth) for line in input)

with open("input.txt") as f:
    inp = f.read().strip().splitlines()

print(solve(inp, 2))
print(solve(inp, 25))
