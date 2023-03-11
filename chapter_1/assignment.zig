const std = @import("std");

pub fn main() void {
    const constant: i32 = 5;
    var variable: u32 = 5000;

    std.debug.print("constant={d} variable={d}\n", .{constant, variable});
}