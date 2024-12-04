use std::{convert::Infallible, str::FromStr};

#[derive(Debug)]
struct Input {

}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        todo!()
    }
}

pub fn part1(input: &str) -> usize {
    todo!()
}

pub fn part2(input: &str) -> usize {
    todo!()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "";

    #[test]
    fn test_part1() {
        assert_eq!(69, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(1337, part2(INPUT));
    }
}
