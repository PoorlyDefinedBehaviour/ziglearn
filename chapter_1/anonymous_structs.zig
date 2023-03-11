const expect = @import("std").testing.expect;



test "anonymous struct literal" {
    const Point = struct {x: i32, y: i32};

    var point: Point = .{
        .x = 13,
        .y = 67,
    };

    try expect(point.x == 13);
    try expect(point.y == 67);
}

test "fully anonymous struct" {
    try dump(.{
        .int = @as(u32, 1234),
        .float = @as(f64, 12.34),
        .b = true,
        .s = "hi"
    });
}

fn dump(args: anytype) !void {
    // Accessing unknown fields fails at runtime.
    if (false) {
        _ = args.unknown;
    }
    try expect(args.int == 1234);
    try expect(args.float == 12.34);
    try expect(args.b);
    try expect(args.s[0] == 'h');
    try expect(args.s[1] == 'i');
}

test "tuple" {
    const values = .{
        @as(u32, 1234),
        @as(f64, 12.34),
        true,
        "hi"
    } ++ .{
        false
    } ** 2;

    try expect(values[0] == 1234);
    try expect(values[4] == false);

    
    // Inline loops(unrolling) must be used to iterate over tuples
    // because each value may have a different type.
    inline for(values) |v, i| {
        if (i != 2) continue;
        try expect(v);
    }

    try expect(values.len == 6);
    try expect(values.@"3"[0] == 'h');
}