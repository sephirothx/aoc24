const std = @import("std");

const input_dir_name = "input";
const cookie_path = ".cookie.session";

pub fn getInputForDayOfYear(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) ![]u8 {
    const yearDir = comptime std.fmt.comptimePrint("{d}", .{year});
    const fileName = comptime std.fmt.comptimePrint("{d}.txt", .{day});
    const filePath = try std.fs.path.join(allocator, &.{ "..", input_dir_name, yearDir, fileName });
    defer allocator.free(filePath);

    std.debug.print("{s}\n", .{filePath});
    var file = try std.fs.cwd().openFile(filePath, .{ .mode = .read_only });
    defer file.close();

    return try file.readToEndAlloc(allocator, std.math.maxInt(usize));
}

pub fn getInputForDay(allocator: std.mem.Allocator, comptime day: u8) ![]u8 {
    const fileName = comptime std.fmt.comptimePrint("{d}.txt", .{day});
    const filePath = try std.fs.path.join(allocator, &.{ "..", input_dir_name, fileName });
    defer allocator.free(filePath);

    std.debug.print("{s}\n", .{filePath});
    var file = try std.fs.cwd().openFile(filePath, .{ .mode = .read_only });
    defer file.close();

    return try file.readToEndAlloc(allocator, std.math.maxInt(usize));
}

pub fn getStringFromFilePath(allocator: std.mem.Allocator, filePath: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filePath, .{ .mode = .read_only });
    defer file.close();

    return try file.readToEndAlloc(allocator, std.math.maxInt(usize));
}

pub fn downloadInputForDay(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) !void {
    var inputDir = try std.fs.cwd().openDir(input_dir_name, .{});
    defer inputDir.close();

    const yearDir = comptime std.fmt.comptimePrint("{d}", .{year});
    inputDir.makeDir(yearDir) catch |e| switch (e) {
        error.PathAlreadyExists => {}, // ignore
        else => return e,
    };

    var fileDir = try inputDir.openDir(yearDir, .{});
    defer fileDir.close();

    const fileName = comptime std.fmt.comptimePrint("{}.txt", .{day});
    const file = try fileDir.createFile(fileName, .{});
    defer file.close();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const url = comptime std.fmt.comptimePrint("https://adventofcode.com/{}/day/{}/input", .{ year, day });
    const uri = try std.Uri.parse(url);

    const headerBuf = try allocator.alloc(u8, 1_000_000);
    defer allocator.free(headerBuf);

    const cwdPath = try std.fs.cwd().realpathAlloc(allocator, ".");
    const sessionCookiePath = try std.fs.path.join(allocator, &.{ cwdPath, cookie_path });
    const sessionCookie = try getStringFromFilePath(allocator, sessionCookiePath);
    const sessionCookieString = try std.fmt.allocPrint(allocator, "session={s}", .{sessionCookie});

    defer allocator.free(cwdPath);
    defer allocator.free(sessionCookiePath);
    defer allocator.free(sessionCookie);
    defer allocator.free(sessionCookieString);

    var request = try client.open(.GET, uri, .{ .server_header_buffer = headerBuf, .extra_headers = &.{
        .{ .name = "Cookie", .value = sessionCookieString },
    } });
    defer request.deinit();

    try request.send();
    try request.finish();
    try request.wait();

    const bytesRead = try request.reader().readAllAlloc(allocator, 10000000);
    defer allocator.free(bytesRead);

    const bytesWritten = try file.write(bytesRead);
    std.debug.assert(bytesRead.len == bytesWritten);
}

pub fn downloadAllInputFiles(allocator: std.mem.Allocator) !void {
    inline for (2015..2024) |year| {
        inline for (1..26) |day| {
            try downloadInputForDay(allocator, @truncate(year), @truncate(day));
        }
    }
}

test "read string from test.txt file" {
    const content = try getInputForDay(std.testing.allocator, 3000, 69);
    defer std.testing.allocator.free(content);

    try std.testing.expectEqualStrings("1337", content);
}
