const expect = @import("std").testing.expect;
const std = @import("std");

var number_left2: u32 = undefined;

fn eventuallyErrorSequence() !u32 {
    if (number_left2 == 0) {
        return error.ReachedZero;
    } else {
        number_left2 -= 1;
        return number_left2;
    }
}

const Info = union(enum) {
    a: u32,
    b: []const u8,
    c,
    d: u32
};

test "optional-if" {
    var maybe_num: ?usize = 10;

    if (maybe_num) |n| {
        try expect(@TypeOf(n) == usize);
        try expect(n == 10);
    } else {
        unreachable;
    }
}

test "error union if" {
    var ent_num: error{UnknownEntity} ! u32 = 5;

    if (ent_num) |entity| {
        try expect(@TypeOf(entity) == u32);
        try expect(entity == 5);
    }  else |err| {
        _ = err catch {};
        unreachable;
    }
}

test "while optional" {
    var i: ?u32 = 10;

    while (i) |num| : (i.? -= 1) {
        try expect(@TypeOf(num) == u32);

        if (num == 1) {
            i = null;
            break;
        }
    }

    try expect(i == null);
}

test "while error union capture" {
    var sum: u32 = 0;
    number_left2 = 3;
    while (eventuallyErrorSequence()) |value| {
        sum += value;
    } else |err| {
        try expect(err == error.ReachedZero);
    }
}

test "for capture" {
    const x = [_]i8{1, 5, 120, -5};
    for (x) |v| try expect(@TypeOf(v) == i8);
}

test "switch capture" {
    var b = Info {.a = 10};

    const x = switch (b) {
        .b => |str| blk: {
            try expect(@TypeOf(str) == []const u8);
            break :blk 1;
        },
        .c => 2,
        .a, .d => |num| blk: {
            try expect(@TypeOf(num) == u32);
            break :blk num * 2;
        }
    };

    try expect(x == 20);
}

test "for with pointer capture" {
    var data = [_]u8{1, 2, 3};
    for (data) |*byte| byte.* += 1;
    try expect(std.mem.eql(u8, &data, &[_]u8{2, 3, 4}));
}