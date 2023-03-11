const expect = @import("std").testing.expect;

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

test "normal pointers cannot be null or 0" {
    var x: u16 = 0;
    var y: *u8 = @intToPtr(*u8, x);
    _ = y;
}

test "const pointers cannot be used to modify a variable" {
    const x: u8 = 1;
    // Const pointer because the variable being reference is const.
    var y = &x;
    y.* += 1;

    // A *T can be corced to *const T.
}

// usize and isze are given as unsigned and signed integers which are
// the same size as pointers.
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}