use std::{collections::{HashMap, HashSet}, convert::Infallible, str::FromStr};
use itertools::Itertools;

#[derive(Debug)]
struct Input {
    antennas: HashMap<char, Vec<(i32, i32)>>,
    size: (i32, i32),
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut antennas = HashMap::new();
        let mut size = (0, 0);
        for (i, line) in s.lines().enumerate() {
            for (j, c) in line.chars().enumerate() {
                if c != '.' {
                    antennas.entry(c).or_insert(Vec::new()).push((i as i32, j as i32));
                }
                size = (i as i32 + 1, j as i32 + 1);
            }
        }
        Ok(Self { antennas, size })
    }
}

pub fn part1(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    find_antinodes(&input, 1, 1).iter().count()
}

pub fn part2(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    find_antinodes(&input, 0, 100).iter().count()
}

fn find_antinodes(input: &Input, start: i32, count: i32) -> HashSet<(i32, i32)> {
    let mut antinodes = HashSet::new();
    for (_, nodes) in &input.antennas {
        for v in nodes.into_iter().combinations(2) {
            let (a1, a2) = v.into_iter().collect_tuple().unwrap();
            let dx = a2.0 - a1.0;
            let dy = a2.1 - a1.1;
            for i in start..start+count {
                insert_if_in_bounds(&mut antinodes, input.size, (a1.0 - i*dx, a1.1 - i*dy));
                insert_if_in_bounds(&mut antinodes, input.size, (a2.0 + i*dx, a2.1 + i*dy));
            }
        }
    }
    antinodes
}

fn insert_if_in_bounds(set: &mut HashSet<(i32, i32)>, bounds: (i32, i32), item: (i32, i32)) {
    if item.0 >= 0 && item.0 < bounds.0 && item.1 >= 0 && item.1 < bounds.1 {
        set.insert(item);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............";

    #[test]
    fn test_part1() {
        assert_eq!(14, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(34, part2(INPUT));
    }
}
