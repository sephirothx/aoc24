with open("input.txt") as f:
    inp = [line.strip() for line in f]

def test(l, curr, res, operators):
    if len(l) == 0:
        return curr == res
    elif curr > res:
        return False
    return any(test(l[1:], op(curr, l[0]), res, operators) for op in operators)

def solve(operators):
    sol = 0
    for s in inp:
        res, num = s.split(": ")
        res = int(res)
        num = list(map(int, num.split()))
        sol += res if test(num[1:], num[0], res, operators) else 0
    print(sol)

solve([lambda x,y: x+y, lambda x,y: x*y])
solve([lambda x,y: x+y, lambda x,y: x*y, lambda x,y: int(str(x)+str(y))])
