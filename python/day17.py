import re

with open("input.txt") as f:
    inp = f.read().strip().split("\n\n")

input_regs = [int(x) for x in re.findall("-?\d+", inp[0])]
instructions = [int(x) for x in re.findall("\d+", inp[1])]

def combo(r, n):
    assert(n != 7)
    if n > 3:
        return r[n - 4]
    return n

def run_program(a, b=0, c=0):
    regs = [a,b,c]
    ip = 0
    while ip < len(instructions):
        op = instructions[ip]
        n = instructions[ip+1]
        if op == 0:
            regs[0] >>= combo(regs, n)
        elif op == 1:
            regs[1] ^= n
        elif op == 2:
            regs[1] = combo(regs, n) % 8
        elif op == 3 and regs[0] != 0:
            ip = n - 2
        elif op == 4:
            regs[1] = regs[1] ^ regs[2]
        elif op == 5:
            yield combo(regs, n) % 8
        elif op == 6:
            regs[1] = regs[0] >> combo(regs, n)
        elif op == 7:
            regs[2] = regs[0] >> combo(regs, n)
        ip += 2

def find_num(l, curr=0, i=0):
    if i >= len(l):
        yield curr
        return
    for d in range(8):
        a = (curr << 3) + d
        output = list(run_program(a))
        if output == l[-(i+1):]:
            yield from find_num(l, a, i + 1)

print(",".join(map(str,run_program(*input_regs))))
print(next(find_num(instructions)))
