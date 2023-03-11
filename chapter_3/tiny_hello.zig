const std = @import("std");

// zig build-exe ./tiny_hello.zig -O ReleaseSmall
pub fn main() void {
    std.io.getStdOut().writeAll("Hello Wortld!") catch unreachable;
}