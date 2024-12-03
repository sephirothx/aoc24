use regex::Regex;

pub fn part1(input: &str) -> usize {
    let re = Regex::new(r"mul\((?<n1>\d+),(?<n2>\d+)\)").unwrap();
    let mut sol = 0;
    for m in re.captures_iter(input) {
        let n1 = m.name("n1").unwrap().as_str().parse::<usize>().unwrap();
        let n2 = m.name("n2").unwrap().as_str().parse::<usize>().unwrap();
        sol += n1 * n2;
    }
    sol
}

pub fn part2(input: &str) -> usize {
    let re = Regex::new(r"(?<mul>mul\((?<n1>\d+),(?<n2>\d+)\))|(?<do>do\(\))|(?<dont>don't\(\))").unwrap();
    let mut sol = 0;
    let mut on = true;
    for m in re.captures_iter(input) {
        if let Some(_) = m.name("mul") {
            if !on { continue }
            let n1 = m.name("n1").unwrap().as_str().parse::<usize>().unwrap();
            let n2 = m.name("n2").unwrap().as_str().parse::<usize>().unwrap();
            sol += n1 * n2;
        } else if let Some(_) = m.name("do") {
            on = true;
        } else if let Some(_) = m.name("dont") {
            on = false;
        }
    }
    sol
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str =
        r"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

    #[test]
    fn test_part1() {
        assert_eq!(161, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(48, part2(INPUT));
    }
}
