#![allow(dead_code)]

mod days;
mod geometry;
mod input;
mod math;

use days::day2::{Input, *};
use input::read_from_file;
use std::str::FromStr;

fn main() {
    let input = Input::from_str(&read_from_file(2)).unwrap();
    use std::time::Instant;
    let now = Instant::now();
    {
        println!("{}", part2(input));
    }
    let elapsed = now.elapsed();
    println!("Elapsed: {:.2?}", elapsed);
}
