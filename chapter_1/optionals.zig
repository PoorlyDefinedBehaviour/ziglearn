const expect = @import("std").testing.expect;

test "optional" {
    var found_index: ?usize = null;

    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };

    for (data) |v, i| {
        if (v == 10) {
            found_index = i;
        }
    }

    // The compiler does not force the programmer to check 
    // if the value is null before using it.
    if (false) {
        found_index += 1;
    }

    try expect(found_index == null);
}

test "orelse" {
    var a: ?f32 = null;
    // b will be 0 because a is null.
    var b = a orelse 0;
    try expect(b == 0);
    try expect(@TypeOf(b) == f32);
}

test "orelse unreachable" {
    const a: ?f32 = 5;
    const b = a orelse unreachable;
    // Same as a orelse unreachable;
    const c = a.?;
    try expect(b == c);
    try expect(@TypeOf(c) == f32);
}

test "if optional payload capture" {
    const a: ?i32 = 5;

    if (a != null) {
        const value = a.?;
        _ = value;
    }

    var b: ?i32 = 5;
    if (b) |*value| {
        value.* += 1;
    }

    try expect(b.? == 6);
}

var numbers_left: u32 = 4;
fn eventuallyNullSequence() ?u32 {
    if (numbers_left == 0) return null;
    numbers_left -=1;
    return numbers_left;
}

test "while null capture" {
    var sum: u32 = 0;
    while (eventuallyNullSequence()) |value| {
        sum += value;
    }

    try expect(sum == 6);
}