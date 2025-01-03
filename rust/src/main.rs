#![allow(dead_code)]

mod days;
mod geometry;
mod input;
mod math;

use days::day9::*;
use input::read_from_file;
use std::time::Instant;

fn main() {
    let input = read_from_file(9);
    let now = Instant::now();
    {
        println!("{}", part2(input.as_str()));
    }
    let elapsed = now.elapsed();
    println!("Elapsed: {:.2?}", elapsed);
}
