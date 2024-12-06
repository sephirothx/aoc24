use std::{collections::HashSet, convert::Infallible, str::FromStr};

use crate::geometry::*;

#[derive(Debug)]
struct Input {
    map: HashSet<(i32, i32)>,
    size: (i32, i32),
    start: (i32, i32),
    dir: Direction,
}

#[derive(PartialEq, Eq, Hash, Clone, Copy)]
struct State {
    pos: (i32, i32),
    dir: Direction,
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut map = HashSet::new();
        let mut start: (i32, i32) = (0, 0);
        let mut dir: Direction = UP;
        let mut size = (0, 0);
        s.lines().enumerate().for_each(|(i, line)| {
            line.chars().enumerate().for_each(|(j, c)| match c {
                '#' => _ = map.insert((i as i32, j as i32)),
                '^' | '>' | 'v' | '<' => {
                    dir = c.try_into().unwrap();
                    start = (i as i32, j as i32);
                }
                _ => size = ((i + 1) as i32, (j + 1) as i32),
            })
        });
        Ok(Self {
            map,
            size,
            start,
            dir,
        })
    }
}

pub fn part1(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    walk(&input).unwrap().len()
}

pub fn part2(input: &str) -> usize {
    let mut sol = 0;
    let mut input = Input::from_str(input).unwrap();
    let set = walk(&input).unwrap();
    for pos in &set {
        input.map.insert(*pos);
        if let None = walk(&input) {
            sol += 1;
        }
        input.map.remove(&pos);
    }
    sol
}

fn walk(input: &Input) -> Option<HashSet<(i32, i32)>> {
    let mut visited = HashSet::new();
    let mut seen = HashSet::new();
    let mut state = State {
        pos: input.start,
        dir: input.dir,
    };
    while state.pos.0 >= 0
        && state.pos.0 < input.size.0
        && state.pos.1 >= 0
        && state.pos.1 < input.size.1
    {
        if seen.contains(&state) {
            return None;
        }
        seen.insert(state);
        visited.insert(state.pos);
        let next = state.pos + state.dir;
        if input.map.contains(&next) {
            state.dir = state.dir.turn_right();
        } else {
            state.pos = next;
        }
    }
    Some(visited)
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...";

    #[test]
    fn test_part1() {
        assert_eq!(41, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(6, part2(INPUT));
    }
}
