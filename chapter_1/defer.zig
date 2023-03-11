const print = @import("std").debug.print;
const expect = @import("std").testing.expect;

test "defer" {
    var x: i16 = 5;

    {
        defer x += 2;
        try expect(x == 5);
    } // defer gets executed here.

    try expect(x == 7);
}

test "defers are executed in reverse order" {
    var x: f32 = 5;

    {
        defer {
            print("\nexecuting x += 2\n", .{});
            x += 2;
         } // Gets executed second.
        defer {
            print("\nexecuting x /= 2\n", .{});
            x /= 2;
         } // Gets executed first.
    }

    try expect(x == 4.5);
}