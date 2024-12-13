import re

with open("input.txt") as f:
    inp = f.read().strip().split("\n\n")

def solve(button_a, button_b, prize):
    ax, ay = button_a
    bx, by = button_b
    px, py = prize

    d1 = ax * by - bx * ay
    d2 = px * by - py * bx
    d3 = py * ax - px * ay

    a = d2 / d1
    b = d3 / d1
    if a.is_integer() and b.is_integer() and a > 0 and b > 0:
        return int(a) * 3 + int(b)
    return 0

part1, part2 = 0, 0

for rule in inp:
    buttons = []
    for m in re.finditer(r"Button [AB]{1}: X\+(?P<x>\d+), Y\+(?P<y>\d+)", rule):
        button = (int(m.group("x")), int(m.group("y")))
        buttons.append(button)
    m = re.findall(r"Prize: X=(\d+), Y=(\d+)", rule)
    prize = list(map(int, *m))
    part1 += solve(buttons[0], buttons[1], prize)
    prize = [prize[0] + 10000000000000, prize[1] + 10000000000000]
    part2 += solve(buttons[0], buttons[1], prize)

print(part1)
print(part2)
