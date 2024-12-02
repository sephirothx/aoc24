const std = @import("std");

pub const Input = struct {
    reports: std.ArrayList(std.ArrayList(i32)),

    pub fn parse(allocator: std.mem.Allocator, input: []const u8) !Input {
        var self = Input{
            .reports = std.ArrayList(std.ArrayList(i32)).init(allocator),
        };
        var lines = std.mem.splitScalar(u8, input, '\n');
        while (lines.next()) |line| {
            if (line.len == 0) continue;
            var report = std.ArrayList(i32).init(allocator);
            var items = std.mem.tokenizeScalar(u8, line, ' ');
            while (items.next()) |item| {
                try report.append(try std.fmt.parseInt(i32, item, 10));
            }
            try self.reports.append(report);
        }
        return self;
    }

    pub fn deinit(self: Input) void {
        for (self.reports.items) |item| {
            item.deinit();
        }
        self.reports.deinit();
    }
};

pub fn part1(allocator: std.mem.Allocator, input: Input) !i32 {
    _ = allocator;
    var sol: i32 = 0;
    for (input.reports.items) |report| {
        sol += if (isValid(report, null)) 1 else 0;
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, input: Input) !i32 {
    _ = allocator;
    var sol: i32 = 0;
    for (input.reports.items) |report| {
        if (isValid(report, null)) {
            sol += 1;
        } else {
            for (0..report.items.len) |i| {
                if (isValid(report, i)) {
                    sol += 1;
                    break;
                }
            }
        }
    }
    return sol;
}

fn isValid(r: std.ArrayList(i32), skip: ?usize) bool {
    var inc = true;
    var dec = true;
    var i: usize = 0;
    while (i < r.items.len - 1) : (i += 1) {
        const n1 = r.items[i];
        var n2 = r.items[i + 1];
        if (skip) |index| {
            if (index == i or (index == i + 1 and i + 2 >= r.items.len)) continue;
            if (index == i + 1) {
                n2 = r.items[i + 2];
            }
        }
        const diff = n2 - n1;
        if (diff >= 0) dec = false;
        if (diff <= 0) inc = false;
        if ((!inc and !dec) or @abs(diff) > 3) return false;
    }
    return true;
}

const TEST_INPUT =
    \\7 6 4 2 1
    \\1 2 7 8 9
    \\9 7 6 2 1
    \\1 3 2 4 5
    \\8 6 4 4 1
    \\1 3 6 7 9
;

test "part 1" {
    const input = try Input.parse(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    try std.testing.expectEqual(2, part1(std.testing.allocator, input));
}

test "part 2" {
    const input = try Input.parse(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    try std.testing.expectEqual(4, part2(std.testing.allocator, input));
}
