use std::fs;
use std::path::Path;

const PATH_TO_INPUT: &str = "../input";

pub fn read_from_file(day: i32) -> String {
    let path = Path::new(PATH_TO_INPUT).join(format!("{day}.txt"));
    println!("{:?}", path);
    fs::read_to_string(path).unwrap()
}

#[cfg(test)]
mod tests {
    #[test]
    fn read_from_file() {
        assert_eq!("69", super::read_from_file(0));
    }
}
