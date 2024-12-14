use std::{convert::Infallible, str::FromStr};

#[derive(Debug)]
struct Equation {
    result: usize,
    nums: Vec<usize>,
}

impl FromStr for Equation {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (result, nums) = s.split_once(": ").unwrap();
        let result = result.parse().unwrap();
        let nums = nums.split_whitespace().map(|n| n.parse().unwrap()).collect();
        Ok(Self { result, nums })
    }
}

#[derive(Debug)]
struct Input {
    equations: Vec<Equation>,
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let equations = s.lines().map(|line| line.parse().unwrap()).collect();
        Ok(Self { equations })
    }
}

pub fn part1(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    let operations: [fn(usize, usize) -> usize; 2] = [
        |a,b| a+b,
        |a,b| a*b,
    ];
    input.equations
        .into_iter()
        .map(|eq| if is_possible(&eq.nums, 1, eq.nums[0], eq.result, &operations) {eq.result} else {0})
        .sum()
}

pub fn part2(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    let operations: [fn(usize, usize) -> usize; 3] = [
        |a,b| a+b,
        |a,b| a*b,
        concat,
    ];
    input.equations
        .into_iter()
        .map(|eq| if is_possible(&eq.nums, 1, eq.nums[0], eq.result, &operations) {eq.result} else {0})
        .sum()
}

fn is_possible(l: &Vec<usize>, i: usize, curr: usize, target: usize, operations: &[fn(usize, usize) -> usize]) -> bool {
    if i == l.len() {
        return curr == target;
    } else if curr > target {
        return false;
    }
    operations
        .iter()
        .any(|op| is_possible(l, i+1, op(curr, l[i]), target, operations))
}

fn concat(a: usize, b: usize) -> usize {
    a * 10_usize.pow(b.ilog10() + 1) + b
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20";

    #[test]
    fn test_part1() {
        assert_eq!(3749, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(11387, part2(INPUT));
    }

    #[test]
    fn test_concat() {
        assert_eq!(666420, concat(666, 420));
        assert_eq!(691337, concat(69, 1337))
    }
}
