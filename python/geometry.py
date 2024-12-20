from typing import Tuple
from multimethod import multimethod

directions = [(1,0), (0,1), (-1,0), (0, -1)]

dir_map = {
    'v': (1,0),
    '>': (0,1),
    '^': (-1,0),
    '<': (0, -1),
}

@multimethod
def add(x1: int, y1: int, x2: int, y2: int) -> Tuple[int, int]:
    return (x1 + x2, y1 + y2)

@multimethod
def add(p1: Tuple[int, int], p2: Tuple[int, int]) -> Tuple[int, int]:
    return add(*p1, *p2)

@multimethod
def sub(x1: int, y1: int, x2: int, y2: int) -> Tuple[int, int]:
    return (x1 - x2, y1 - y2)

@multimethod
def sub(p1: Tuple[int, int], p2: Tuple[int, int]) -> Tuple[int, int]:
    return sub(*p1, *p2)

@multimethod
def get_neighbors(pos: Tuple[int, int]) -> list[Tuple[int, int]]:
    return [add(pos, d) for d in directions]

@multimethod
def get_neighbors(x: int, y: int) -> list[Tuple[int, int]]:
    return get_neighbors((x, y))

@multimethod
def turn_left(x: int, y: int) -> Tuple[int, int]:
    return (-y, x)

@multimethod
def turn_left(pos: Tuple[int, int]) -> Tuple[int, int]:
    return turn_left(*pos)

@multimethod
def turn_right(x: int, y: int) -> Tuple[int, int]:
    return (y, -x)

@multimethod
def turn_right(pos: Tuple[int, int]) -> Tuple[int, int]:
    return turn_right(*pos)

@multimethod
def reverse(x: int, y: int) -> Tuple[int, int]:
    return (-x, -y)

@multimethod
def reverse(pos: Tuple[int, int]) -> Tuple[int, int]:
    return reverse(*pos)

@multimethod
def manhattan_distance(x1: int, y1: int, x2: int, y2: int) -> Tuple[int, int]:
    return abs(x1 - x2) + abs(y1 - y2)

@multimethod
def manhattan_distance(p1: Tuple[int, int], p2: Tuple[int, int]) -> Tuple[int, int]:
    return manhattan_distance(*p1, *p2)

@multimethod
def is_in_bounds(x: int, y: int, lower_x: int, lower_y: int, upper_x: int, upper_y: int) -> bool:
    return lower_x <= x < upper_x and lower_y <= y < upper_y

@multimethod
def is_in_bounds(pos: Tuple[int, int], lower: Tuple[int, int], upper: Tuple[int, int]) -> bool:
    return is_in_bounds(*pos, *lower, *upper)

if __name__ == '__main__':
    assert((69, 420) == add((60, 20), (9, 400)))
    assert((69, 420) == sub((420, 1337), (351, 917)))
    assert(all(d in directions for d in get_neighbors(0, 0)))
    assert(dir_map['<'] == turn_left(dir_map['^']))
    assert(dir_map['v'] == turn_left(dir_map['<']))
    assert(dir_map['>'] == turn_left(dir_map['v']))
    assert(dir_map['^'] == turn_left(dir_map['>']))
    assert(dir_map['<'] == turn_right(turn_left(dir_map['<'])))
    assert(dir_map['v'] == turn_right(turn_left(dir_map['v'])))
    assert(dir_map['>'] == turn_right(turn_left(dir_map['>'])))
    assert(dir_map['^'] == turn_right(turn_left(dir_map['^'])))
    assert(dir_map['<'] == reverse(dir_map['>']))
    assert(dir_map['v'] == reverse(dir_map['^']))
    assert(dir_map['>'] == reverse(dir_map['<']))
    assert(dir_map['^'] == reverse(dir_map['v']))
    assert(69 == manhattan_distance((13, 37), (73, 28)))
    assert(is_in_bounds((69, 420), (50, 400), (100, 1337)))
    assert(not is_in_bounds((69, 420), (50, 666), (100, 1337)))
