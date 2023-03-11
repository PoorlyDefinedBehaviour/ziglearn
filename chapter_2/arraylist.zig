const std = @import("std");
const test_allocator = std.testing.allocator;
const expect = std.testing.expect;

test "ArrayList" {
    var list = std.ArrayList(u8).init(test_allocator);
    defer list.deinit();
    try list.append('H');
    try list.append('e');
    try list.append('l');
    try list.append('l');
    try list.append('o');
    try list.appendSlice(" World!");

    try expect(std.mem.eql(u8, list.items, "Hello World!"));
}