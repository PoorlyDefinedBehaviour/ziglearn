const expect = @import("std").testing.expect;

fn func3() u32 {}

test "async / await" {
    var frame = async func3();
    try expect(await frame == 5);
}