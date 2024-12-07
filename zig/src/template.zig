const std = @import("std");

pub const Input = struct {
    // TODO

    pub fn parse(allocator: std.mem.Allocator, input: []const u8) !Input {
        // TODO
    }

    pub fn deinit(self: Input) void {
        // TODO
    }
};

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !u32 {
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    // TODO
}

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !u32 {
    const input = try Input.parse(allocator, s);
    defer input.deinit();
    // TODO
}

const TEST_INPUT = "";

test "part 1" {
    try std.testing.expectEqual(69, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(1337, part2(std.testing.allocator, TEST_INPUT));
}
