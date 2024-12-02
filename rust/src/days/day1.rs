use std::{convert::Infallible, str::FromStr};

#[derive(Debug)]
pub struct Input {
    columns: [Vec<i32>; 2],
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut columns: [Vec<i32>; 2] = std::array::from_fn(|_| Vec::new());
        s.lines().for_each(|line| {
            let (n1, n2) = line.split_once("   ").unwrap();
            columns[0].push(n1.parse().unwrap());
            columns[1].push(n2.parse().unwrap());
        });
        Ok(Input { columns })
    }
}

pub fn part1(input: Input) -> i32 {
    let mut v1 = input.columns[0].clone();
    let mut v2 = input.columns[1].clone();
    v1.sort();
    v2.sort();
    v1.into_iter().zip(v2).map(|(n1, n2)| (n1 - n2).abs()).sum()
}

pub fn part2(input: Input) -> i32 {
    let v1 = input.columns[0].clone();
    let v2 = input.columns[1].clone();
    v1.into_iter()
        .map(|n| n * v2.iter().filter(|&&i| i == n).count() as i32)
        .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
3   4
4   3
2   5
1   3
3   9
3   3";

    #[test]
    fn test_part1() {
        assert_eq!(11, part1(INPUT.parse().unwrap()));
    }

    #[test]
    fn test_part2() {
        assert_eq!(31, part2(INPUT.parse().unwrap()));
    }
}
