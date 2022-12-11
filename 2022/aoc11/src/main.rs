use std::collections::{VecDeque, HashMap};
use lazy_static::lazy_static;
use regex::Regex;

#[derive(Copy, Clone)]
enum Val {
    Old,
    Val(i32)
}

#[derive(Copy, Clone)]
enum Op {
    Add(Val),
    Mult(Val)
}

struct Monkey {
   items: VecDeque<i32>,
   op: Op,
   test: i32,
   true_monkey: usize,
   false_monkey: usize,
   inspection_count: i32,
   is_part1: bool
}

struct Monkeys {
    bois: Vec<Monkey>
}

type MonkeyRecv = HashMap<usize, VecDeque<i32>>;

impl Monkeys {
    fn throw(self: &mut Self) {
        for i in 0..self.bois.len() {
            let mut results: MonkeyRecv = HashMap::new();
            self.bois[i].throw(&mut results);
            for m in results.keys() {
                for j in 0..results[m].len() {
                    // Some(item) = results.get(m).unwrap().pop_front() {
                    self.recv(*m, *results[m].get(j).unwrap())
                }
            }
        }
    }

    fn recv(self: &mut Self, monkey_id: usize, item: i32) {
        self.bois[monkey_id].recv(item);
    }

    fn get_inspection_count(self: &mut Self) -> i32 {
        self.bois.sort_by(|m1, m2| m1.inspection_count.cmp(&m2.inspection_count));
        self.bois.pop().unwrap().inspection_count * self.bois.pop().unwrap().inspection_count
    }
}

fn handle_add(op_val: Val, item: i32) -> i32 {
    match op_val {
        Val::Old => item + item,
        Val::Val(val) => item + val
    }
}

fn handle_mult(op_val: Val, item: i32) -> i32 {
    match op_val {
        Val::Old => item * item,
        Val::Val(val) => item * val
    }
}

impl Monkey {
    fn throw(self: &mut Self, results: &mut MonkeyRecv) {
        results.insert(self.true_monkey, VecDeque::new());
        results.insert(self.false_monkey, VecDeque::new());
        while let Some(mut item) = self.items.pop_front() {
            item = match self.op {
                Op::Add(val) => handle_add(val, item),
                Op::Mult(val) => handle_mult(val, item)
            };
            if self.is_part1 {
                item = item / 3;
            }
            if item % self.test == 0 {
                results.get_mut(&self.true_monkey).unwrap().push_back(item);
            } else {
                results.get_mut(&self.false_monkey).unwrap().push_back(item);
            }
            self.inspection_count += 1;
        }
    }

    fn recv(self: &mut Self, item: i32) {
        self.items.push_back(item);
    }
}

fn parse_monkey(input: &str, is_part1: bool) -> Monkey {
    lazy_static! {
        static ref RE: Regex = Regex::new(
            // r"\s*Monkey [0-9]+:\s*"
            // r"Starting items: (?P<items>(?:(?:\d)+, )*(?:\d)+)\s*"
            // r"Operation: new = old (?P<op>[\*\+] (?:\d+|old|new))\s*"
            // r"Test: divisible by (?P<test>\d+)\s*"
            // r"If true: throw to monkey (?P<true>\d+)\s*"
            // "If false: throw to monkey (?P<false>\d+)\s*").unwrap();
            r"\s*Monkey [0-9]+:\s*Starting items: (?P<items>(?:(?:\d)+, )*(?:\d)+)\s*Operation: new = old (?P<op>[\*\+] (?:\d+|old|new))\s*Test: divisible by (?P<test>\d+)\s*If true: throw to monkey (?P<true>\d+)\s*If false: throw to monkey (?P<false>\d+)\s*").unwrap();
    }
    let capture = RE.captures(input).unwrap();
    let items: VecDeque<i32> = capture
        .name("items")
        .unwrap()
        .as_str()
        .split(", ")
        .map(|item| item.parse::<i32>().unwrap())
        .collect();
    let op_vec: Vec<&str> = capture.name("op").unwrap().as_str().split(" ").collect();
    let operand: Val = match op_vec[1] {
        "old" => Val::Old,
        val => Val::Val(val.parse::<i32>().unwrap())
    };
    let op: Op = match op_vec[0] {
        "*" => Op::Mult(operand),
        "+" => Op::Add(operand),
        &_ => panic!()
    };
    let test = capture.name("test").unwrap().as_str().parse::<i32>().unwrap();
    let true_monkey = capture.name("true").unwrap().as_str().parse::<usize>().unwrap();
    let false_monkey = capture.name("false").unwrap().as_str().parse::<usize>().unwrap();

    Monkey {
        items: items,
        op: op,
        test: test,
        true_monkey: true_monkey,
        false_monkey: false_monkey,
        inspection_count: 0,
        is_part1: is_part1
    }
}

fn part1() {
    let mut monkeys: Monkeys = Monkeys {
        bois: include_str!("input")
        .trim()
        .split("\n\n")
        .map(|input| parse_monkey(input, true))
        .collect()
    };

    for _cycle in 0..20 {
        monkeys.throw()
    }

    println!("{}", monkeys.get_inspection_count());
}

fn part2() {
    let mut monkeys: Monkeys = Monkeys {
        bois: include_str!("input")
        .trim()
        .split("\n\n")
        .map(|input| parse_monkey(input, false))
        .collect()
    };

    for _cycle in 0..10000 {
        monkeys.throw()
    }

    println!("{}", monkeys.get_inspection_count());
}


fn main() {
    part1();
    part2()
}
