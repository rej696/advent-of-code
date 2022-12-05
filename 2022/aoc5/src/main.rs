#[macro_use] extern crate sscanf;
use std::collections::VecDeque;

fn part1() {
    let mut crates: Vec<Vec<char>> = vec![
        vec!['B', 'Z', 'T'],
        vec!['V', 'H', 'T', 'D', 'N'],
        vec!['B', 'F', 'M', 'D'],
        vec!['T', 'J', 'G', 'W', 'V', 'Q', 'L'],
        vec!['W', 'D', 'G', 'P', 'V', 'F', 'Q', 'M'],
        vec!['V', 'Z', 'Q', 'G', 'H', 'F', 'S'],
        vec!['Z', 'S', 'N', 'R', 'L', 'T', 'C', 'W'],
        vec!['Z', 'H', 'W', 'D', 'J', 'N', 'R', 'M'],
        vec!['M', 'Q', 'L', 'F', 'D', 'S']
    ];

    let input: Vec<&str> = include_str!("input")
        .trim()
        .split("\n\n")
        .collect::<Vec<&str>>()[1]
        .split("\n")
        .collect();

    input.into_iter()
        .map(|line| {
            let (n, f, t): (i32, usize, usize) =
                            sscanf!(line, "move {i32} from {usize} to {usize}").unwrap();

            let mut count: i32 = 0;
            while count < n {
                let tmp: char = crates[f - 1].pop().unwrap();
                crates[t - 1].push(tmp);
                count += 1;
            }
        })
        .for_each(drop);

    let result: String = crates
        .into_iter()
        .map(|stack| {
            let c: char = *stack.last().unwrap();
            c
        })
        .collect();

    println!("{}", result);

}

fn part2() {
    let mut crates: Vec<Vec<char>> = vec![
        vec!['B', 'Z', 'T'],
        vec!['V', 'H', 'T', 'D', 'N'],
        vec!['B', 'F', 'M', 'D'],
        vec!['T', 'J', 'G', 'W', 'V', 'Q', 'L'],
        vec!['W', 'D', 'G', 'P', 'V', 'F', 'Q', 'M'],
        vec!['V', 'Z', 'Q', 'G', 'H', 'F', 'S'],
        vec!['Z', 'S', 'N', 'R', 'L', 'T', 'C', 'W'],
        vec!['Z', 'H', 'W', 'D', 'J', 'N', 'R', 'M'],
        vec!['M', 'Q', 'L', 'F', 'D', 'S']
    ];

    let input: Vec<&str> = include_str!("input")
        .trim()
        .split("\n\n")
        .collect::<Vec<&str>>()[1]
        .split("\n")
        .collect();

    input.into_iter()
        .map(|line| {
            let (n, f, t): (i32, usize, usize) =
                            sscanf!(line, "move {i32} from {usize} to {usize}").unwrap();

            let mut count: i32 = 0;
            let mut tmp: VecDeque<char> = VecDeque::new();
            while count < n {
                tmp.push_front(crates[f - 1].pop().unwrap());
                count += 1;
            }
            count = 0;
            while count < n {
                crates[t - 1].push(tmp.pop_front().unwrap());
                count += 1;
            }
        })
        .for_each(drop);

    let result: String = crates
        .into_iter()
        .map(|stack| {
            let c: char = *stack.last().unwrap();
            c
        })
        .collect();

    println!("{}", result);
}

fn main() {
    part1();
    part2();
}
