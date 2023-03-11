const expect = @import("std").testing.expect;

const decimal_int: i32 = 9822;
const hex_int: u8 = 0xff;
const another_hex_int: u8 = 0xFF;
const octal_int: u16 = 0o755;
const binary_int: u8 = 0b11110000;

// Visual separators can be used to improve readability.
const one_billion: u64 = 1_000_000_000;
const binary_mask: u64 = 0b1_1111_1111;
const permissions: u64 = 0o7_5_5;
const big_address: u64 = 0xFF80_0000_0000_0000;

test "integers can be cast to another type of integer as long as the type supports all the values from the original type" {
    const a: u8 = 250;
    const b: u16 = a;
    const c: u32 = b;
    try expect(c == a);
}

test "casting an integer to a type that cannot fit all values from the origina type" {
    const x: u64 = 200;
    // Fails at runtime if the new type cannot fit the value.
    const y = @intCast(u8, x);
    try expect(@TypeOf(y) == u8);
}

test "overflow operators" {
    var a: u8 = 255;
    a +%= 1;
    try expect(a == 0);
}