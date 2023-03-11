const expect = @import("std").testing.expect;
const std = @import("std");

fn double(x: u32) u32 {
    return x * 2;
}

fn Matrix(
    // The function parameters are tagged with comptime which means
    // that it will only accept values known at compile-time.
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

fn addSmallInts(comptime T: type, a: T, b: T) T {
    return switch (@typeInfo(T)) {
        .ComptimeInt => a + b,
        .Int => |info| if (info.bits <= 16) a + b else @compileError("ints too large"),
        else => @compileError("only ints accepted")
    };
}

fn GetBiggerInt(comptime T: type) type {
    return @Type(.{
        .Int = .{
            .bits = @typeInfo(T).Int.bits + 1,
            .signedness = @typeInfo(T).Int.signedness
        }
    });
}

fn Vec(comptime count: comptime_int, comptime T: type) type {
    return struct {
        data: [count]T,
        const Self = @This();

        fn abs(self: Self) Self {
            var tmp = Self{ .data = undefined };

            for (self.data) |elem, i| {
                tmp.data[i] = if (elem < 0 ) -elem else elem;
            }

            return tmp;
        }

        fn init(data: [count]T) Self {
            return Self { .data = data };
        }
    };
}

fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "comptime blocks" {
    var x = comptime double(10);
    _ = x;

    var y = comptime blk: {
        break :blk double(10);
    };

    _ = y;
}

test "comptime_int" {
    const a = 12;
    const b = a + 10;

    const c: u4 = a;
    _ = c;

    const d: f32 = b;
    _ = d;
}

test "types in Zig are values of the type `type`. they can be used as values" {
    const a = 5;

    const b: if (a < 10) f32 else i32 = 5;

    _ = b;
}

test "returning a type" {
    try expect(Matrix(f32, 4, 4) == [4][4]f32);
}

test "typeinfo switch" {
    const x = addSmallInts(u16, 20, 30);
    try expect(@TypeOf(x) == u16);
    try expect(x == 50);
}

test "@Type" {
    try expect(GetBiggerInt(u8) == u9);
    try expect(GetBiggerInt(i31) == i32);
}

test "generic vector" {
    const x = Vec(3, f32).init([_]f32{ 10, -10, 5 });
    const y = x.abs();
    try expect(std.mem.eql(f32, &y.data, &[_]f32{ 10, 10, 5 }));
}

test "inferred function parameter" {
    try expect(plusOne(@as(u32, 1)) == 2);
}

test "++" {
    const x: [4]u8 = undefined;
    const y = x[0..];

    const a: [6]u8 = undefined;
    const b = a[0..];

    const new = y ++ b;
    try expect(new.len == 10);
}

test "**" {
    const pattern = [_]u8{ 0xCC, 0xAA };
    const memory = pattern ** 3;

    try expect(std.mem.eql(u8, &memory, &[_]u8{ 0xCC, 0xAA, 0xCC, 0xAA, 0xCC, 0xAA }));
}