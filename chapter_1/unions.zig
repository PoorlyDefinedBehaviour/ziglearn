const expect = @import("std").testing.expect;

const Result = union {
    int: i64,
    float: f64,
    bool: bool
};

const Tag = enum { a, b, c };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

// Tags are inferred, equivalent to Tagged.
const InferredTagged = union(enum) { a: u8, b: f32, c: bool };

// Void member types can have their type ommitted from the syntax(seems useless).
const VoidMember = union(enum) { a: u8, b: f32, c: bool, none };

test "simple union" {
    var result = Result{ .int = 1234 };
    // Will compile and fail at runtime.
    result.float = 12.34;
}

test "switch on tagged union" {
    var value = Tagged{ .b = 1.5 };

    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }

    // Accessing an inactive tagged union field only fails at runtime.
    if (false) {
        try expect(value.a == 2);
    }

    try expect(value.b == 3);
}