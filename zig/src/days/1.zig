const std = @import("std");

pub const Input = struct {
    columns: [2]std.ArrayList(i32),

    pub fn parse_input(allocator: std.mem.Allocator, input: []const u8) !Input {
        var self = Input{
            .columns = [2]std.ArrayList(i32){
                std.ArrayList(i32).init(allocator),
                std.ArrayList(i32).init(allocator),
            },
        };
        var lines = std.mem.splitScalar(u8, input, '\n');
        while (lines.next()) |line| {
            var items = std.mem.tokenizeScalar(u8, line, ' ');
            for (&self.columns) |*column| {
                const n = try std.fmt.parseInt(i32, items.next().?, 10);
                try column.*.append(n);
            }
        }
        return self;
    }

    pub fn deinit(self: Input) void {
        self.list1.deinit();
        self.list2.deinit();
    }
};

pub fn part1(allocator: std.mem.Allocator, input: Input) !u32 {
    _ = allocator;
    const list1 = input.columns[0];
    const list2 = input.columns[1];
    var sol: u32 = 0;
    std.sort.pdq(i32, list1.items, {}, std.sort.asc(i32));
    std.sort.pdq(i32, list2.items, {}, std.sort.asc(i32));
    for (list1.items, list2.items) |n1, n2| {
        sol += @abs(n1 - n2);
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, input: Input) !i32 {
    _ = allocator;
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
    const input = try Input.parse_input(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    try std.testing.expectEqual(11, part1(std.testing.allocator, input));
}

test "part 2" {
    const input = try Input.parse_input(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    try std.testing.expectEqual(31, part2(std.testing.allocator, input));
}
