const std = @import("std");
const alloc = std.heap.page_allocator;

const data = @embedFile("input.txt");
pub const std_options = .{ .log_level = .info };

pub fn p1(input: []const u8) !u32 {
    var lines = std.mem.tokenizeAny(u8, input, "\n");
    // var report = std.ArrayList(u32).init(alloc);
    var count: u32 = 0;
    var idx: u32 = 0;

    while (lines.next()) |line| {
        // split line by whitespace and add each value into a seperate list
        var spliterator = std.mem.tokenizeAny(u8, line, " ");
        var increasing = false;
        var decreasing = false;
        var safe = true;
        var first = true;
        var last: i32 = 0;
        while (spliterator.next()) |item| {
            const v = try std.fmt.parseInt(i32, item, 10);
            if (first) {
                last = v;
                first = false;
                continue;
            }

            if (v == last) {
                std.log.debug("\tthe same! (v: {!}, last: {!})", .{ v, last });
                safe = false;
            } else if (v > last) {
                std.log.debug("\tincreasing! (v: {!}, last: {!})", .{ v, last });
                if (((v - last) > 3) or decreasing) {
                    std.log.debug("\t\tincreasing but unsafe (dec: {!})", .{decreasing});
                    safe = false;
                } else {
                    std.log.debug("\t\tincreasing but safe", .{});
                    increasing = true;
                }
            } else if (v < last) {
                std.log.debug("\tdecreasing! (v: {!}, last: {!})", .{ v, last });
                if (((last - v) > 3) or increasing) {
                    std.log.debug("\t\tdecreasing but unsafe (inc: {!})", .{increasing});
                    safe = false;
                } else {
                    std.log.debug("\t\tdecreasing but safe", .{});
                    decreasing = true;
                }
            }
            std.log.debug("idx: {!}, v: {!}, last: {!}, safe: {!}, dec: {!}, inc: {!}", .{ idx, v, last, safe, decreasing, increasing });

            if (!safe) {
                break;
            }
            last = v;
        }
        if (safe) {
            count += 1;
        }
        idx += 1;
    }
    return count;
}

pub fn p2(input: []const u8) !u32 {
    _ = input;
    return 31;
}

pub fn main() !void {
    const result1 = p1(data);

    std.log.info("p1: {!}\n", .{result1});

    const result2 = p2(data);

    std.log.debug("p2: {!}\n", .{result2});
}

const test_input = "7 6 4 2 1\n1 2 7 8 9\n9 7 6 2 1\n1 3 2 4 5\n8 6 4 4 1\n1 3 6 7 9\n";

test "p1" {
    std.testing.log_level = std.log.Level.debug;
    const result = p1(test_input);
    try std.testing.expectEqual(@as(u32, 2), result);
}

test "p2" {
    const result = p2(test_input);
    try std.testing.expectEqual(@as(u32, 4), result);
}
