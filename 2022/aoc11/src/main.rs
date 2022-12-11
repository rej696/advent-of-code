use std::collections::{VecDeque, HashMap};
use lazy_static::lazy_static;
use regex::Regex;
use num::integer::lcm;

#[derive(Copy, Clone)]
enum Val {
    Old,
    Val(i64)
}

#[derive(Copy, Clone)]
enum Op {
    Add(Val),
    Mult(Val)
}

impl Op {
    fn apply(&self, item: i64) -> i64{
        match self {
            Op::Add(val) => handle_add(*val, item),
            Op::Mult(val) => handle_mult(*val, item)
        }
    }
}

struct Monkey {
   items: VecDeque<i64>,
   op: Op,
   test: i64,
   true_monkey: usize,
   false_monkey: usize,
   inspection_count: i64,
   relief: i64,
}

struct Monkeys {
    bois: Vec<Monkey>,
    factor: i64
}

type MonkeyRecv = HashMap<usize, VecDeque<i64>>;

impl Monkeys {
    fn throw(self: &mut Self) {
        for i in 0..self.bois.len() {
            let mut results: MonkeyRecv = HashMap::new();
            self.bois[i].throw(self.factor, &mut results);
            for m in results.keys() {
                for j in 0..results[m].len() {
                    // Some(item) = results.get(m).unwrap().pop_front() {
                    self.recv(*m, *results[m].get(j).unwrap())
                }
            }
        }
    }

    fn recv(self: &mut Self, monkey_id: usize, item: i64) {
        self.bois[monkey_id].recv(item);
    }

    fn get_inspection_count(self: &mut Self) -> i64 {
        self.bois.sort_by(|m1, m2| m1.inspection_count.cmp(&m2.inspection_count));
        self.bois.pop().unwrap().inspection_count * self.bois.pop().unwrap().inspection_count
    }

    fn debug(&self) {
        for i in 0..self.bois.len() {
            println!("Monkey {}, {}", i, self.bois[i].inspection_count)
        }
    }
}

fn handle_add(op_val: Val, item: i64) -> i64 {
    match op_val {
        Val::Old => item + item,
        Val::Val(val) => item + (val as i64)
    }
}

fn handle_mult(op_val: Val, item: i64) -> i64 {
    match op_val {
        Val::Old => {
            //println!("Debug square item: {}", item);
            item * item
        },
        Val::Val(val) => item * (val as i64)
    }
}

impl Monkey {
    fn throw(self: &mut Self, factor: i64, results: &mut MonkeyRecv) {
        results.insert(self.true_monkey, VecDeque::new());
        results.insert(self.false_monkey, VecDeque::new());
        while let Some(mut item) = self.items.pop_front() {
            item = self.op.apply(item) / self.relief % factor;
            if item % self.test == 0 {
                results.get_mut(&self.true_monkey).unwrap().push_back(item);
            } else {
                results.get_mut(&self.false_monkey).unwrap().push_back(item);
            }
            self.inspection_count += 1;
        }
    }

    fn recv(self: &mut Self, item: i64) {
        self.items.push_back(item);
    }
}

fn parse_monkey(input: &str, relief: i64) -> Monkey {
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
    let items: VecDeque<i64> = capture
        .name("items")
        .unwrap()
        .as_str()
        .split(", ")
        .map(|item| item.parse::<i64>().unwrap())
        .collect();
    let op_vec: Vec<&str> = capture.name("op").unwrap().as_str().split(" ").collect();
    let operand: Val = match op_vec[1] {
        "old" => Val::Old,
        val => Val::Val(val.parse::<i64>().unwrap())
    };
    let op: Op = match op_vec[0] {
        "*" => Op::Mult(operand),
        "+" => Op::Add(operand),
        &_ => panic!()
    };
    let test = capture.name("test").unwrap().as_str().parse::<i64>().unwrap();
    let true_monkey = capture.name("true").unwrap().as_str().parse::<usize>().unwrap();
    let false_monkey = capture.name("false").unwrap().as_str().parse::<usize>().unwrap();

    Monkey {
        items: items,
        op: op,
        test: test,
        true_monkey: true_monkey,
        false_monkey: false_monkey,
        inspection_count: 0,
        relief: relief
    }
}

fn part1() {
    let bois: Vec<Monkey>= include_str!("input")
        .trim()
        .split("\n\n")
        .map(|input| parse_monkey(input, 3))
        .collect();

    let factor = bois.iter()
        .map(|m| m.test)
        .fold(1, lcm);

    let mut monkeys: Monkeys = Monkeys {
        bois: bois,
        factor: factor
    };

    for _cycle in 0..20 {
        monkeys.throw()
    }

    println!("{}", monkeys.get_inspection_count());
}

fn part2() {
    let bois: Vec<Monkey>= include_str!("input")
        .trim()
        .split("\n\n")
        .map(|input| parse_monkey(input, 1))
        .collect();

    let factor = bois.iter()
        .map(|m| m.test)
        .fold(1, lcm);

    let mut monkeys: Monkeys = Monkeys {
        bois: bois,
        factor: factor
    };

    for _cycle in 0..10000 {
        // if cycle % 1000 == 0
        //     || cycle == 20
        //     || cycle == 1 {
        //     monkeys.debug();
        // }

        monkeys.throw();
    }

    println!("{}", monkeys.get_inspection_count());
}


fn main() {
    part1();
    part2()
}
