use std::cmp::min;

pub fn part1(input: &str) -> usize {
    let mut sol = 0;
    let mut files = input.chars().map(|c| c.to_digit(10).unwrap() as usize).collect::<Vec<_>>();
    let mut lo = 0;
    let mut hi = files.len() - 1;
    let mut pos = 0;
    while lo <= hi {
        let mut n = files[lo];
        let mut file_id = lo / 2;
        if lo % 2 == 1 {
            n = min(n, files[hi]);
            file_id = hi / 2;
            files[hi] -= n;
            if files[hi] == 0 {
                hi -= 2;
            }
        }
        sol += sum_ints(pos, n) * file_id;
        pos += n;
        files[lo] -= n;
        if files[lo] == 0 {
            lo += 1;
        }
    }
    sol
}

#[derive(Debug)]
struct File {
    id: usize,
    pos: usize,
    size: usize,
}

#[derive(Debug)]
struct Hole {
    pos: usize,
    size: usize,
}

pub fn part2(input: &str) -> usize {
    let mut sol = 0;
    let mut files = Vec::new();
    let mut holes = Vec::new();
    let mut pos = 0;
    for (i, c) in input.chars().enumerate() {
        let size = c.to_digit(10).unwrap() as usize;
        if i % 2 == 0 {
            let id = i / 2;
            let file = File { id, pos, size };
            files.push(file);
        } else {
            let hole = Hole { pos, size };
            holes.push(hole);
        }
        pos += size;
    }
    for f in files.iter_mut().rev() {
        // // Idiomatic but slower than the `for` loop
        // if let Some(h) = holes.iter_mut().find(|h| h.pos < f.pos && h.size >= f.size) {
        //     f.pos = h.pos;
        //     h.pos += f.size;
        //     h.size -= f.size;
        // }
        for h in holes.iter_mut() {
            if h.pos >= f.pos { break }
            if h.size >= f.size {
                f.pos = h.pos;
                h.pos += f.size;
                h.size -= f.size;
                break
            }
        }
        sol += sum_ints(f.pos, f.size) * f.id;
    }
    sol
}

fn sum_ints(from: usize, count: usize) -> usize {
    count * (2 * from + count - 1) / 2
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "2333133121414131402";

    #[test]
    fn test_part1() {
        assert_eq!(1928, part1(INPUT));
    }

    #[test]
    fn test_part2() {
        assert_eq!(2858, part2(INPUT));
    }

    #[test]
    fn test_sum_ints() {
        assert_eq!(15, sum_ints(4, 3));
    }
}
