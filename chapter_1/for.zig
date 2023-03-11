const expect = @import("std").testing.expect;

test "for" {
    // Character literals are equivalent to integer literals.
    const string = [_]u8{'a', 'b', 'c'};

    for (string) |character| {
        _ = character;
    }

    for (string) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}