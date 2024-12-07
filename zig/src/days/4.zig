const std = @import("std");

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !u32 {
    _ = allocator;
    const col = std.mem.indexOfScalar(u8, s, '\n').? + 1;
    var sol: u32 = 0;
    for (0..col) |i| {
        for (0..col - 3) |j| {
            var arr: [4][4]u8 = .{.{0} ** 4} ** 4;
            arr[0] = [4]u8{ s[i * col + j], s[i * col + j + 1], s[i * col + j + 2], s[i * col + j + 3] };
            arr[1] = [4]u8{ s[j * col + i], s[(j + 1) * col + i], s[(j + 2) * col + i], s[(j + 3) * col + i] };
            if (i < col - 3) {
                const jj = col - j - 1;
                arr[2] = [4]u8{ s[i * col + j], s[(i + 1) * col + j + 1], s[(i + 2) * col + j + 2], s[(i + 3) * col + j + 3] };
                arr[3] = [4]u8{ s[i * col + jj], s[(i + 1) * col + jj - 1], s[(i + 2) * col + jj - 2], s[(i + 3) * col + jj - 3] };
            }
            for (arr) |word| {
                if (std.mem.eql(u8, &word, "XMAS") or std.mem.eql(u8, &word, "SAMX")) {
                    sol += 1;
                }
            }
        }
    }
    return sol;
}

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !u32 {
    _ = allocator;
    const col = std.mem.indexOfScalar(u8, s, '\n').? + 1;
    var sol: u32 = 0;
    for (1..col - 1) |i| {
        for (1..col - 1) |j| {
            const d1 = [_]u8{ s[(i - 1) * col + j - 1], s[i * col + j], s[(i + 1) * col + j + 1] };
            const d2 = [_]u8{ s[(i - 1) * col + j + 1], s[i * col + j], s[(i + 1) * col + j - 1] };
            if ((std.mem.eql(u8, &d1, "MAS") or std.mem.eql(u8, &d1, "SAM")) and
                (std.mem.eql(u8, &d2, "MAS") or std.mem.eql(u8, &d2, "SAM")))
            {
                sol += 1;
            }
        }
    }
    return sol;
}

const TEST_INPUT =
    \\MMMSXXMASM
    \\MSAMXMSMSA
    \\AMXSXMAAMM
    \\MSAMASMSMX
    \\XMASAMXAMM
    \\XXAMMXXAMA
    \\SMSMSASXSS
    \\SAXAMASAAA
    \\MAMMMXMMMM
    \\MXMXAXMASX
;

test "part 1" {
    try std.testing.expectEqual(18, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(9, part2(std.testing.allocator, TEST_INPUT));
}
