const expect = @import("std").testing.expect;

fn total(a: *align(64) const [64]u8) u32 {
    var sum: u32 = 0;

    for (a) |elem| {
        sum += elem;
    }

    return sum;
}

test "aligned pointers" {
    const a: u32 align(8) = 5;
    try expect(@TypeOf(&a) == *align(8) const u32);
}

test "passing aligned data" {
    const x align(64) = [_]u8{10} ** 64;
    try expect(total(&x) == 640);
}