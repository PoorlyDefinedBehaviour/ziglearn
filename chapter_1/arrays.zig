const std = @import("std");

pub fn main() void {
    const a = [5]u8{'h', 'e', 'l', 'l', 'o'};
    // Infer the array size.
    const b = [_]u8{'w', 'o', 'r', 'l', 'd'};

    std.debug.print("a={any} b={any}\n", .{a, b});

    std.debug.print("a.len()={d} b.len()={d}\n", .{a.len, b.len});
}