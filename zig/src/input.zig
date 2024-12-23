const std = @import("std");

const input_dir_name = "input";
const cookie_path = ".cookie.session";

pub fn getInputForDayCached(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) ![]const u8 {
    return readCachedInputForDay(allocator, year, day) catch {
        try downloadInputForDay(allocator, year, day);
        return try readCachedInputForDay(allocator, year, day);
    };
}

pub fn fetchInputForDay(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) ![]const u8 {
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const url = comptime std.fmt.comptimePrint("https://adventofcode.com/{}/day/{}/input", .{ year, day });
    const uri = try std.Uri.parse(url);

    const headerBuf = try allocator.alloc(u8, 1_000_000);
    defer allocator.free(headerBuf);

    const cwdPath = try std.fs.cwd().realpathAlloc(allocator, ".");
    const sessionCookiePath = try std.fs.path.join(allocator, &.{ cwdPath, cookie_path });
    const sessionCookie = try readStringFromFile(allocator, sessionCookiePath);
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

    return std.mem.trim(u8, try request.reader().readAllAlloc(allocator, std.math.maxInt(usize)), "\n");
}

pub fn buildFilePath(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) ![]u8 {
    const yearDir = comptime std.fmt.comptimePrint("{d}", .{year});
    const fileName = comptime std.fmt.comptimePrint("{d}.txt", .{day});
    const filePath = try std.fs.path.join(allocator, &.{ "..", input_dir_name, yearDir, fileName });
    return filePath;
}

pub fn readCachedInputForDay(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) ![]u8 {
    const filePath = try buildFilePath(allocator, year, day);
    defer allocator.free(filePath);

    return readStringFromFile(allocator, filePath);
}

pub fn readStringFromFile(allocator: std.mem.Allocator, filePath: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filePath, .{ .mode = .read_only });
    defer file.close();

    return try file.readToEndAlloc(allocator, std.math.maxInt(usize));
}

pub fn downloadInputForDay(allocator: std.mem.Allocator, comptime year: u16, comptime day: u8) !void {
    const filePath = try buildFilePath(allocator, year, day);
    defer allocator.free(filePath);

    const cwd = std.fs.cwd();

    std.fs.cwd().makePath(std.fs.path.dirname(filePath).?) catch |err| switch (err) {
        error.PathAlreadyExists => {}, // ignore
        else => return err,
    };

    const file = try cwd.createFile(filePath, .{});
    defer file.close();

    const bytesRead = try fetchInputForDay(allocator, year, day);
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
