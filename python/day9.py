with open("input.txt") as f:
    inp = list(map(int, f.read().strip()))

def build_disk(lengths):
    disk = []
    fid = 0
    for i, length in enumerate(inp):
        disk.extend([fid] * length if i % 2 == 0 else [-1] * length)
        if i % 2 == 0:
            fid += 1
    return disk

def checksum(disk):
    return sum(i * block for i, block in enumerate(disk) if block != -1)

def part1(disk):
    lo, hi = 0, len(disk) - 1
    while lo < hi:
        if disk[lo] == -1:
            if disk[hi] != -1:
                disk[lo], disk[hi] = disk[hi], disk[lo]
            hi -= 1
        else:
            lo += 1
    return checksum(disk)

def part2(disk):
    files = []
    holes = []
    is_hole = False
    for i, fid in enumerate(disk):
        if fid == -1:
            if not is_hole:
                is_hole = True
                holes.append([i, 0]) #(start, len)
            holes[-1][1] += 1
        else:
            is_hole = False
            if len(files) == 0 or files[-1][0] != fid:
                files.append([fid, i, 0]) # (id, start, length)
            files[-1][2] += 1

    def find_hole(start, length):
        for hole in holes:
            if hole[1] >= length and hole[0] < start:
                return hole
        return None

    for fid, s, l in reversed(files):
        hole = find_hole(s, l)
        if hole:
            hs, hl = hole
            disk[s:s + l] = [-1] * l
            disk[hs:hs + l] = [fid] * l
            if hl == l:
                holes.remove(hole)
            else:
                hole[0] += l
                hole[1] -= l
    return checksum(disk)

print(part1(build_disk(inp)))
print(part2(build_disk(inp)))
