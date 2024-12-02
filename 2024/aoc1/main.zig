const std = @import("std");
const alloc = std.heap.page_allocator;

const data = @embedFile("input.txt");

pub fn parse(input: []const u8) !struct { std.ArrayList(i32), std.ArrayList(i32) } {
    var lines = std.mem.tokenizeAny(u8, input, "\n");
    var list_a = std.ArrayList(i32).init(alloc);
    var list_b = std.ArrayList(i32).init(alloc);

    while (lines.next()) |line| {
        // split line by whitespace and add each value into a seperate list
        var spliterator = std.mem.tokenizeAny(u8, line, " ");
        const a = try std.fmt.parseInt(i32, spliterator.next().?, 10);
        const b = try std.fmt.parseInt(i32, spliterator.next().?, 10);
        try list_a.append(a);
        try list_b.append(b);
    }
    return .{ list_a, list_b };
}

pub fn p1(input: []const u8) !u32 {
    var lists = try parse(input);
    const r_a = try lists[0].toOwnedSlice();
    const r_b = try lists[1].toOwnedSlice();

    std.mem.sort(i32, r_a, {}, std.sort.asc(i32));
    std.mem.sort(i32, r_b, {}, std.sort.asc(i32));
    var sum: u32 = 0;
    for (r_a, r_b) |a, b| {
        sum += @abs(a - b);
    }
    return sum;
}

pub fn p2(input: []const u8) !u32 {
    var lists = try parse(input);
    const r_a = try lists[0].toOwnedSlice();
    const r_b = try lists[1].toOwnedSlice();
    var map = std.AutoHashMap(i32, i32).init(alloc);
    for (r_b) |value| {
        if (map.get(value)) |count| {
            try map.put(value, count + 1);
        } else {
            try map.put(value, 1);
        }
    }

    var sum: u32 = 0;

    for (r_a) |value| {
        var m: i32 = 0;
        if (map.get(value)) |count| {
            m = count;
        }
        sum += @abs(value * m);
    }

    return sum;
}

pub fn main() !void {
    const result1 = p1(data);

    std.debug.print("p1: {!}\n", .{result1});

    const result2 = p2(data);

    std.debug.print("p2: {!}\n", .{result2});
}

test "p1" {
    const test_input = "3   4\n4   3\n2   5\n1   3\n3   9\n3   3\n";
    const result = p1(test_input);
    try std.testing.expectEqual(@as(u32, 11), result);
}

test "p2" {
    const test_input = "3   4\n4   3\n2   5\n1   3\n3   9\n3   3\n";
    const result = p2(test_input);
    try std.testing.expectEqual(@as(u32, 31), result);
}
