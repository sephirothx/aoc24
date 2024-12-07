const std = @import("std");

pub const Input = struct {
    rules: std.ArrayList([2]i32),
    lists: std.ArrayList(std.ArrayList(i32)),

    pub fn parse(allocator: std.mem.Allocator, input: []const u8) !Input {
        var self = Input{
            .rules = std.ArrayList([2]i32).init(allocator),
            .lists = std.ArrayList(std.ArrayList(i32)).init(allocator),
        };
        var parts = std.mem.splitSequence(u8, input, "\n\n");
        var rules = std.mem.splitScalar(u8, parts.next().?, '\n');
        var lists = std.mem.splitScalar(u8, parts.next().?, '\n');
        while (rules.next()) |rule_line| {
            var nums = std.mem.splitScalar(u8, rule_line, '|');
            const n1 = try std.fmt.parseInt(i32, nums.next().?, 10);
            const n2 = try std.fmt.parseInt(i32, nums.next().?, 10);
            try self.rules.append(.{ n1, n2 });
        }
        while (lists.next()) |list_line| {
            var list = std.ArrayList(i32).init(allocator);
            var nums = std.mem.tokenizeScalar(u8, list_line, ',');
            while (nums.next()) |n| {
                try list.append(try std.fmt.parseInt(i32, n, 10));
            }
            try self.lists.append(list);
        }
        return self;
    }

    pub fn deinit(self: Input) void {
        self.rules.deinit();
        for (self.lists.items) |item| {
            item.deinit();
        }
        self.lists.deinit();
    }
};

const Context = struct {
    rules: []const [2]i32,
    fn lessThan(self: Context, lhs: i32, rhs: i32) bool {
        for (self.rules) |rule| {
            if (rule[0] == rhs and rule[1] == lhs) {
                return false;
            }
        }
        return true;
    }
};

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !i32 {
    var sol: i32 = 0;
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const context = Context{ .rules = input.rules.items };
    for (input.lists.items) |list| {
        if (std.sort.isSorted(i32, list.items, context, Context.lessThan)) {
            sol += list.items[list.items.len / 2];
        }
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !i32 {
    var sol: i32 = 0;
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    const context = Context{ .rules = input.rules.items };
    for (input.lists.items) |list| {
        if (!std.sort.isSorted(i32, list.items, context, Context.lessThan)) {
            std.mem.sort(i32, list.items, context, Context.lessThan);
            sol += list.items[list.items.len / 2];
        }
    }
    return sol;
}

const TEST_INPUT =
    \\47|53
    \\97|13
    \\97|61
    \\97|47
    \\75|29
    \\61|13
    \\75|53
    \\29|13
    \\97|29
    \\53|29
    \\61|53
    \\97|53
    \\61|29
    \\47|13
    \\75|47
    \\97|75
    \\47|61
    \\75|61
    \\47|29
    \\75|13
    \\53|13
    \\
    \\75,47,61,53,29
    \\97,61,53,29,13
    \\75,29,13
    \\75,97,47,61,53
    \\61,13,29
    \\97,13,75,29,47
;

test "part 1" {
    try std.testing.expectEqual(143, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(123, part2(std.testing.allocator, TEST_INPUT));
}
