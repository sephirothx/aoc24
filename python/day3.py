import re

with open("./input.txt") as f:
    inp = f.read()

part1 = sum(int(m.group("n1")) * int(m.group("n2")) for m in re.finditer(r"mul\((?P<n1>\d+),(?P<n2>\d+)\)", inp))
print(part1)

part2, on = 0, True
for match in re.finditer(r"(?P<mul>mul\((?P<n1>\d+),(?P<n2>\d+)\))|(?P<do>do\(\))|(?P<dont>don't\(\))", inp):
    if match.group("mul") and on:
        part2 += int(match.group("n1")) * int(match.group("n2"))
    elif match.group("do"):
        on = True
    elif match.group("dont"):
        on = False
print(part2)
