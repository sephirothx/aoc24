const std = @import("std");

const Entry = struct {
    res: usize,
    nums: [31]usize,
};

pub const Input = struct {
    entries: std.ArrayList(Entry),

    pub fn parse(allocator: std.mem.Allocator, input: []const u8) !Input {
        var lines = std.mem.splitScalar(u8, input, '\n');
        var self = Input{ .entries = std.ArrayList(Entry).init(allocator) };
        while (lines.next()) |line| {
            var entry: Entry = undefined;
            var tokens = std.mem.tokenizeAny(u8, line, " ,:");
            entry.res = try std.fmt.parseInt(usize, tokens.next().?, 10);
            var i: usize = 0;
            while (tokens.next()) |n| : (i += 1) {
                entry.nums[i] = try std.fmt.parseInt(usize, n, 10);
            }
            entry.nums[i] = 0;
            try self.entries.append(entry);
        }
        return self;
    }

    pub fn deinit(self: Input) void {
        self.entries.deinit();
    }
};

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !usize {
    var sol: usize = 0;
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const operations = [_]*const fn (usize, usize) usize{ add, mul };
    for (input.entries.items) |entry| {
        sol += if (possible(entry.nums[1..], entry.nums[0], entry.res, &operations)) entry.res else 0;
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !usize {
    var sol: usize = 0;
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const operations = [_]*const fn (usize, usize) usize{ add, mul, concat };
    for (input.entries.items) |entry| {
        sol += if (possible(entry.nums[1..], entry.nums[0], entry.res, &operations)) entry.res else 0;
    }
    return sol;
}

fn possible(l: []const usize, curr: usize, target: usize, operations: []const *const fn (usize, usize) usize) bool {
    if (l[0] == 0) {
        return curr == target;
    }
    if (curr > target) {
        return false;
    }
    for (operations) |op| {
        if (possible(l[1..], op(curr, l[0]), target, operations)) {
            return true;
        }
    }
    return false;
}

fn add(a: usize, b: usize) usize {
    return a + b;
}

fn mul(a: usize, b: usize) usize {
    return a * b;
}

fn concat(a: usize, b: usize) usize {
    var multiplier: usize = 1;
    var temp = b;
    while (temp != 0) : (temp /= 10) {
        multiplier *= 10;
    }
    return a * multiplier + b;
}

const TEST_INPUT =
    \\190: 10 19
    \\3267: 81 40 27
    \\83: 17 5
    \\156: 15 6
    \\7290: 6 8 6 15
    \\161011: 16 10 13
    \\192: 17 8 14
    \\21037: 9 7 18 13
    \\292: 11 6 16 20
;

test "part 1" {
    try std.testing.expectEqual(3749, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(11387, part2(std.testing.allocator, TEST_INPUT));
}

test "concat" {
    try std.testing.expectEqual(133769, concat(1337, 69));
}
