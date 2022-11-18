use std::include_str;
use std::collections::HashSet;

fn is_lowest<F>(col: i32, row: i32, data: &Vec<Vec<i32>>, check_edge_case: &F) -> bool
where
    F: Fn(i32, i32) -> bool,
{
    for i in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
        let dcol = col + i.1;
        let drow = row + i.0;
        if check_edge_case(dcol, drow) {
            // Edges only check exiting neighbors
            continue;
        }
        if data[drow as usize][dcol as usize] <= data[row as usize][col as usize] {
            // val is not the lowest
            return false;
        }
    }
    true
}

fn find_basin<F>(
    mut size: i32,
    col: i32,
    row: i32,
    data: &Vec<Vec<i32>>,
    check_edge_case: &F,
    checked: &mut HashSet<(i32, i32)>,
) -> i32
where
    F: Fn(i32, i32) -> bool,
{
    if check_edge_case(col, row)
        || data[row as usize][col as usize] == 9
        || checked.contains(&(col, row))
    {
        return size;
    }
    checked.insert((col, row));
    for i in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
        let dcol = col + i.1;
        let drow = row + i.0;
        size = find_basin(size, dcol, drow, data, check_edge_case, checked) + 1;
    }
    size
}

fn main() {
    // find the locations that are lower than any adjacent locations
    // risk level is 1 + height of low point
    // sum all the risk levels

    // Read input file, and convert to 2D array of digits
    let data: Vec<Vec<i32>> = include_str!("input")
        .trim()
        .lines()
        .map(|line| {
            line.chars()
                .map(|c| c.to_digit(10).expect("Invalid Input") as i32)
                .collect()
        })
        .collect();

    let num_cols = data[0].len() as i32;
    let num_rows = data.len() as i32;

    // Part One
    let check_edge_case = |x, y| x < 0 || x >= num_cols || y < 0 || y >= num_rows;
    let mut result: i32 = 0;

    // Loop over array to find low points (indicies)
    for col in 0..num_cols {
        for row in 0..num_rows {
            if is_lowest(col, row, &data, &check_edge_case) {
                // store values of low points
                result += data[row as usize][col as usize] + 1;
            }
        }
    }

    println!("Part 1: {}", result);

    // Part 2
    // Loop over array to find basins
    let mut basins: Vec<i32> = vec![0, 0, 0];
    let mut checked: HashSet<(i32, i32)> = HashSet::new();
    for col in 0..num_cols {
        for row in 0..num_rows {
            let size = find_basin(0, col, row, &data, &check_edge_case, &mut checked);
            if size > basins[0] {
                basins.insert(0, size);
            } else if size > basins[1] {
                basins.insert(1, size);
            } else if size > basins[2] {
                basins.insert(2, size);
            }
        }
    }

    // Product of top 3 basins
    let mut result: i32 = 1;
    for i in 0..3 {
        println!("Basin sizes: {}", basins[i]);
        result *= basins[i];
    }

    println!("Part 2: {}", result);
}
