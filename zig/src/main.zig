const std = @import("std");
const f = @import("input.zig");
const day = @import("days/5.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input = try f.fetchInputForDay(allocator, 2024, 5);
    defer allocator.free(input);

    var timer = try std.time.Timer.start();
    const solution = day.part2(allocator, input);
    const time = @as(f32, @floatFromInt(timer.read())) / 1_000_000.0;

    std.debug.print("{!}\n", .{solution});
    std.debug.print("Execution time: {d} ms\n", .{time});
}
