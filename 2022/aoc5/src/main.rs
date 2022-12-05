#[macro_use]
extern crate sscanf;
use std::collections::VecDeque;

fn parse_crates() -> Vec<Vec<char>> {
    let mut input: Vec<&str> = include_str!("input")
        .split("\n\n")
        .nth(0)
        .unwrap()
        .split("\n")
        .collect();

    let mut stacks: Vec<Vec<char>> = input
        .last()
        .unwrap()
        .trim()
        .split_whitespace()
        .map(|_| Vec::new())
        .collect();

    let num_stacks: usize = stacks.len();

    input.pop();

    for line in input.iter().rev() {
        for i in 0..num_stacks {
            let c = line.chars().nth(i * 4 + 1).unwrap_or(' ');
            if i * 4 + 1 < line.len() && c != ' ' {
                stacks[i].push(c);
            }
        }
    }

    stacks
}

fn parse_commands() -> Vec<&'static str> {
    include_str!("input")
        .trim()
        .split("\n\n")
        .nth(1)
        .unwrap()
        .split("\n")
        .collect()
}

fn crates2res(crates : &Vec<Vec<char>>) -> String {
    crates.iter()
        .map(|stack| *stack.last().unwrap())
        .collect()
}

fn part1() {
    let mut crates: Vec<Vec<char>> = parse_crates();
    // let input: Vec<&'static str> = parse_commands();

    for line in parse_commands().into_iter() {
        let (n, f, t): (i32, usize, usize) =
            sscanf!(line, "move {i32} from {usize} to {usize}").unwrap();

        let mut count: i32 = 0;
        while count < n {
            let tmp: char = crates[f - 1].pop().unwrap();
            crates[t - 1].push(tmp);
            count += 1;
        }
    }

    println!("part1 : {}", crates2res(&crates));
}

fn part2() {
    let mut crates: Vec<Vec<char>> = parse_crates();

    for line in parse_commands().into_iter() {
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
    }

    println!("part2 : {}", crates2res(&crates));
}

fn main() {
    let old_crates: Vec<Vec<char>> = vec![
        vec!['B', 'Z', 'T'],
        vec!['V', 'H', 'T', 'D', 'N'],
        vec!['B', 'F', 'M', 'D'],
        vec!['T', 'J', 'G', 'W', 'V', 'Q', 'L'],
        vec!['W', 'D', 'G', 'P', 'V', 'F', 'Q', 'M'],
        vec!['V', 'Z', 'Q', 'G', 'H', 'F', 'S'],
        vec!['Z', 'S', 'N', 'R', 'L', 'T', 'C', 'W'],
        vec!['Z', 'H', 'W', 'D', 'J', 'N', 'R', 'M'],
        vec!['M', 'Q', 'L', 'F', 'D', 'S'],
    ];
    let new_crates: Vec<Vec<char>> = parse_crates();

    for i in 0..9 {
        for j in 0..new_crates[i].len() {
            assert_eq!(new_crates[i][j], old_crates[i][j]);
        }
    }

    part1();
    part2();
}
