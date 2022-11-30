fn main() {
    let mut elves: Vec<i32> = include_str!("input")
        .trim()
        .split("\n\n")
        .map(|elf_lines| {
            elf_lines
                .trim()
                .lines()
                .map(|line| line.parse::<i32>().unwrap())
                .fold(0, |acc, x| acc + x)
        })
        .collect();

    elves.sort_by(|a, b| b.cmp(a));
    println!("{}", elves[0]);
    println!("{}", elves[0] + elves[1] + elves[2]);
}
