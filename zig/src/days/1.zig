const std = @import("std");

pub const Input = struct {
    columns: [2]std.ArrayList(i32),

    pub fn parse(allocator: std.mem.Allocator, input: []const u8) !Input {
        var self = Input{
            .columns = [2]std.ArrayList(i32){
                std.ArrayList(i32).init(allocator),
                std.ArrayList(i32).init(allocator),
            },
        };
        var lines = std.mem.splitScalar(u8, input, '\n');
        while (lines.next()) |line| {
            if (line.len == 0) continue;
            var items = std.mem.tokenizeScalar(u8, line, ' ');
            for (&self.columns) |*column| {
                const n = try std.fmt.parseInt(i32, items.next().?, 10);
                try column.*.append(n);
            }
        }
        return self;
    }

    pub fn deinit(self: Input) void {
        for (&self.columns) |*column| {
            column.*.deinit();
        }
    }
};

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !u32 {
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const list1 = input.columns[0];
    const list2 = input.columns[1];
    var sol: u32 = 0;
    std.mem.sort(i32, list1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, std.sort.asc(i32));
    for (list1.items, list2.items) |n1, n2| {
        sol += @abs(n1 - n2);
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !i32 {
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const list1 = input.columns[0];
    const list2 = input.columns[1];
    var sol: i32 = 0;
    for (list1.items) |a| {
        var count: i32 = 0;
        for (list2.items) |b| {
            if (a == b) count += 1;
        }
        sol += count * a;
    }
    return sol;
}

const TEST_INPUT =
    \\3   4
    \\4   3
    \\2   5
    \\1   3
    \\3   9
    \\3   3
;

test "part 1" {
    try std.testing.expectEqual(11, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(31, part2(std.testing.allocator, TEST_INPUT));
}
