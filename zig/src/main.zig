const std = @import("std");
const f = @import("input.zig");
const day = @import("days/9.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input = try f.getInputForDayCached(allocator, 2024, 9);
    defer allocator.free(input);

    for (0..100) |_| {
        var timer = try std.time.Timer.start();
        var solution = day.part1(allocator, input);
        var time = @as(f32, @floatFromInt(timer.read())) / 1_000_000.0;

        std.debug.print("{!}\n", .{solution});
        std.debug.print("Execution time: {d} ms\n", .{time});

        timer.reset();
        solution = day.part2(allocator, input);
        time = @as(f32, @floatFromInt(timer.read())) / 1_000_000.0;

        std.debug.print("{!}\n", .{solution});
        std.debug.print("Execution time: {d} ms\n", .{time});
    }
}
