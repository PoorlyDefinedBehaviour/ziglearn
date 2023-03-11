const expect = @import("std").testing.expect;

var foo: i32 = 1;
var bar: i32 = 1;

test "suspend with no resume" {
    var frame = async func(); // 1
    _ = frame;
    try expect(foo == 2); // 4
}

fn func() void {
    foo += 1; // 2
    suspend {} // 3
    foo += 1; // never reached
} 

test "suspend with resume" {
    var frame = async func2(); // 1
    resume frame; // 4
    try expect(bar == 3);
}

fn func2() void {
    bar += 1; // 2
    suspend {} // 3
    bar += 1; // 5
}