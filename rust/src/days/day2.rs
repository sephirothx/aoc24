use std::{convert::Infallible, str::FromStr};

#[derive(Debug)]
struct Input {
    reports: Vec<Vec<i32>>,
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let reports = s
            .lines()
            .map(|line| {
                line.split_ascii_whitespace()
                    .map(|n| n.parse::<i32>().unwrap())
                    .collect()
            })
            .collect();
        Ok(Input { reports })
    }
}

pub fn part1(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    input
        .reports
        .into_iter()
        .filter(|report| is_report_valid(report))
        .count()
}

pub fn part2(input: &str) -> usize {
    let input = Input::from_str(input).unwrap();
    input
        .reports
        .into_iter()
        .filter(|report| {
            is_report_valid(report)
                || (0..report.len()).any(|i| {
                    let mut new_report = report.clone();
                    new_report.remove(i);
                    is_report_valid(&new_report)
                })
        })
        .count()
}

fn is_report_valid(report: &Vec<i32>) -> bool {
    let mut inc = true;
    let mut dec = true;
    for pair in report.windows(2) {
        let diff = pair[1] - pair[0];
        if diff > 0 {
            dec = false;
        } else if diff < 0 {
            inc = false;
        }
        if diff.abs() < 1 || diff.abs() > 3 || !dec && !inc {
            return false;
        }
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9";

    #[test]
    fn test_part1() {
        assert_eq!(2, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(4, part2(INPUT));
    }
}
