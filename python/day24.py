import networkx as nx
import matplotlib.pyplot as plt

with open("input.txt") as f:
    a, b = f.read().strip().split("\n\n")

inputs = {}
for line in a.splitlines():
    name, value = line.split(': ')
    value = int(value) == 1
    inputs[name] = value
gates = []
for line in b.splitlines():
    op, result = line.split(" -> ")
    op1, op, op2 = op.split()
    gates.append((op1, op2, result, op))

while gates:
    again = []
    for gate in gates:
        op1, op2, result, op = gate
        if op1 not in inputs or op2 not in inputs:
            again.append(gate)
            continue
        op1, op2 = inputs[op1], inputs[op2]
        inputs[result] = op1 and op2 if op == 'AND' else op1 or op2 if op == 'OR' else op1 != op2
    gates = again

n = 0
for input in reversed(sorted(inputs)):
    if input.startswith('z'):
        n = (n << 1) + (1 if inputs[input] else 0)
print(n)
