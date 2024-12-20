import re
from typing import Tuple

def get_all_positions_of(needle: str, haystack: list[str]) -> list[Tuple[int, int]]:
    return [(x, y) for x, line in enumerate(haystack) for y, c in enumerate(line) if c == needle]

def get_all_ints(s: str) -> list[int]:
    return list(map(int, re.findall(r"(-?\d+)", s)))

if __name__ == "__main__":
    haystack = ["....#...",
                "..#.....",
                "........",
                "......#."]
    expected = [(0, 4), (1, 2), (3, 6)]
    assert(expected == get_all_positions_of("#", haystack))
    assert([69, 420, 1337, -1] == get_all_ints("nice 69 let's 420 be 1337 negative -1"))
