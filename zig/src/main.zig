const std = @import("std");
const f = @import("file.zig");
const day = @import("days/1.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const text = try f.getInputForDay(allocator, 1);
    const input = try day.Input.parse_input(allocator, text);
    defer allocator.destroy(&input);

    var timer = try std.time.Timer.start();
    const solution = day.part1(allocator, input);
    const time = @as(f32, @floatFromInt(timer.read())) / 1_000_000.0;

    std.debug.print("{!}\n", .{solution});
    std.debug.print("Execution time: {d}ms\n", .{time});
}
