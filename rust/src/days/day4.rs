pub fn part1(input: &str) -> usize {
    let m = input.lines().map(|line| line.as_bytes()).collect::<Vec<_>>();
    let mut sol = 0;
    for i in 0..m.len() {
        for j in 0..m.len() - 3 {
            let mut v = Vec::new();
            v.push([m[i][j], m[i][j+1], m[i][j+2], m[i][j+3]]);
            v.push([m[j][i], m[j+1][i], m[j+2][i], m[j+3][i]]);
            if i < m.len() - 3 {
                let jj = m.len() - j - 1;
                v.push([m[i][j], m[i+1][j+1], m[i+2][j+2], m[i+3][j+3]]);
                v.push([m[i][jj], m[i+1][jj-1], m[i+2][jj-2], m[i+3][jj-3]]);
            }
            for x in v {
                match &x {
                    b"XMAS" | b"SAMX" => sol += 1,
                    _ => (),
                }
            }
        }
    }
    sol
}

pub fn part2(input: &str) -> usize {
    let m = input.lines().map(|line| line.as_bytes()).collect::<Vec<_>>();
    let mut sol = 0;
    for i in 1..m.len()-1 {
        for j in 1..m.len()-1 {
            let d1 = [m[i-1][j-1], m[i][j], m[i+1][j+1]];
            let d2 = [m[i+1][j-1], m[i][j], m[i-1][j+1]];
            if (&d1 == b"MAS" || &d1 == b"SAM") && (&d2 == b"MAS" || &d2 == b"SAM") {
                sol += 1;
            }
        }
    }
    sol
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "\
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";

    #[test]
    fn test_part1() {
        assert_eq!(18, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(9, part2(INPUT));
    }
}
