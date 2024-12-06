use std::{collections::HashMap, convert::Infallible, str::FromStr};

#[derive(Debug)]
struct Input {
    rules: Vec<(i32, i32)>,
    lists: Vec<Vec<i32>>,
}

impl FromStr for Input {
    type Err = Infallible;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (rules, lists) = s.split_once("\n\n").unwrap();
        let rules = rules
            .lines()
            .map(|line| {
                let (n1, n2) = line.split_once('|').unwrap();
                let n1 = n1.parse::<i32>().unwrap();
                let n2 = n2.parse::<i32>().unwrap();
                (n1, n2)
            })
            .collect();
        let lists = lists
            .lines()
            .map(|line| line.split(',').map(|n| n.parse::<i32>().unwrap()).collect())
            .collect();
        Ok(Self { rules, lists })
    }
}

pub fn part1(input: &str) -> usize {
    let mut sol = 0;
    let input = Input::from_str(input).unwrap();
    'outer: for list in input.lists {
        let mid = list[list.len() / 2] as usize;
        let map = list
            .into_iter()
            .enumerate()
            .map(|(index, item)| (item, index))
            .collect::<HashMap<_, _>>();
        for (n1, n2) in &input.rules {
            if map.contains_key(n1) && map.contains_key(n2) && map[n1] > map[n2] {
                continue 'outer;
            }
        }
        sol += mid;
    }
    sol
}

pub fn part2(input: &str) -> usize {
    let mut sol = 0;
    let mut input = Input::from_str(input).unwrap();
    for list in &mut input.lists {
        if needed_sorting(list, &input.rules) {
            sol += list[list.len() / 2] as usize;
        }
    }
    sol
}

pub fn needed_sorting(l: &mut Vec<i32>, rules: &Vec<(i32, i32)>) -> bool {
    let mut ret = false;
    for i in 0..l.len() - 1 {
        for j in i..l.len() {
            if rules.contains(&(l[j], l[i])) {
                l.swap(i, j);
                ret = true;
            }
        }
    }
    ret
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47";

    #[test]
    fn test_part1() {
        assert_eq!(143, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(123, part2(INPUT));
    }
}
