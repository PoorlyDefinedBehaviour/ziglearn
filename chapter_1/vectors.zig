const std = @import("std");
const expect = @import("std").testing.expect;

test "vector add" {
    const x: std.meta.Vector(4, f32) = .{1, -10, 20, -1};
    const y: std.meta.Vector(4, f32) = .{2, 10, 0, 1};
    const z = x + y;
    try expect(std.meta.eql(z, std.meta.Vector(4, f32){3, 0, 20, 0}));
}

test "vector indexing" {
    const x: std.meta.Vector(4, u8) = .{255, 0, 255, 0};
    try expect(x[0] == 255);
}

test "vector * scalar" {
    const x: std.meta.Vector(3, f32) = .{12.5, 37.5, 2.5};
    const y = x * @splat(3, @as(f32, 2));
    try expect(std.meta.eql(y, std.meta.Vector(3, f32){25, 75, 5}));
}