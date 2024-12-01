const std = @import("std");

pub const Input = struct {
    // TODO

    pub fn parse_input(allocator: std.mem.Allocator, input: []const u8) !Input {
        // TODO
    }

    pub fn deinit(self: Input) void {
        // TODO
    }
};

pub fn part1(allocator: std.mem.Allocator, input: Input) !u32 {
    // TODO
}

pub fn part2(allocator: std.mem.Allocator, input: Input) !i32 {
    // TODO
}

const TEST_INPUT = "";

test "part 1" {
    const input = try Input.parse_input(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    // TODO
    try std.testing.expectEqual(69, part1(std.testing.allocator, input));
}

test "part 2" {
    const input = try Input.parse_input(std.testing.allocator, TEST_INPUT);
    defer input.deinit();
    // TODO
    try std.testing.expectEqual(1337, part2(std.testing.allocator, input));
}
