const std = @import("std");

pub fn part1(allocator: std.mem.Allocator, s: []const u8) !usize {
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    for (s) |c| {
        try list.append(c - '0');
    }
    var files = list.items;
    var checksum: usize = 0;
    var lo: usize = 0;
    var hi: usize = files.len - 1;
    var pos: usize = 0;
    while (lo <= hi) {
        var count = files[lo];
        var fileId = lo / 2;
        if (lo % 2 == 1) {
            fileId = hi / 2;
            count = @min(count, files[hi]);
            files[hi] -= count;
            hi -= if (files[hi] == 0) 2 else 0;
        }
        checksum += sumInts(pos, count) * fileId;
        pos += count;
        files[lo] -= count;
        lo += if (files[lo] == 0) 1 else 0;
    }
    return checksum;
}

const File = struct {
    id: usize,
    pos: usize,
    count: u8,
};

const Hole = struct {
    pos: usize,
    count: u8,
};

pub fn part2(allocator: std.mem.Allocator, s: []const u8) !usize {
    var files_list = std.ArrayList(File).init(allocator);
    var holes_list = std.ArrayList(Hole).init(allocator);
    defer files_list.deinit();
    defer holes_list.deinit();
    var pos: usize = 0;
    for (s, 0..) |c, i| {
        const n = c - '0';
        if (i % 2 == 0) {
            try files_list.append(File{ .id = i / 2, .pos = pos, .count = n });
        } else {
            try holes_list.append(Hole{ .pos = pos, .count = n });
        }
        pos += n;
    }
    const files = files_list.items;
    const holes = holes_list.items;
    var checksum: usize = 0;
    var i: isize = @as(isize, @intCast(files.len)) - 1;
    while (i >= 0) : (i -= 1) {
        var file = files[@intCast(i)];
        for (holes) |*hole| {
            if (hole.pos > file.pos) break;
            if (hole.count >= file.count) {
                file.pos = hole.pos;
                hole.pos += file.count;
                hole.count -= file.count;
            }
        }
        checksum += sumInts(file.pos, file.count) * file.id;
    }
    return checksum;
}

fn sumInts(from: usize, count: usize) usize {
    return count * (2 * from + count - 1) / 2;
}

const TEST_INPUT = "2333133121414131402";

test "part 1" {
    try std.testing.expectEqual(1928, part1(std.testing.allocator, TEST_INPUT));
}

test "part 2" {
    try std.testing.expectEqual(2858, part2(std.testing.allocator, TEST_INPUT));
}
