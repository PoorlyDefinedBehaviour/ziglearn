const std = @import("std");
const expect = std.testing.expect;

const ConstainsIterator = struct {
    strings: []const []const u8,
    needle: []const u8,
    index: usize = 0,

    fn next(self: *ConstainsIterator) ?[]const u8 {
        const index = self.index;

        for(self.strings[index..]) |string| {
            self.index += 1;

            if (std.mem.indexOf(u8, string, self.needle)) |_| {
                return string;
            }
        }

        return null;
    }
};

test "split iterator" {
    const text = "robust, optimal, reusable, maintainable, ";

    var iter = std.mem.split(u8, text, ", ");

    try expect(std.mem.eql(u8, iter.next().?, "robust"));
    try expect(std.mem.eql(u8, iter.next().?, "optimal"));
    try expect(std.mem.eql(u8, iter.next().?, "reusable"));
    try expect(std.mem.eql(u8, iter.next().?, "maintainable"));
    try expect(std.mem.eql(u8, iter.next().?, ""));
    try expect(iter.next() == null);
}

test "iterator looping" {
    var iter = (try std.fs.cwd().openIterableDir(".", .{})).iterate();

    var file_count: usize = 0;
    while(try iter.next()) |entry| {
        if(entry.kind == .File) {
            file_count += 1;
        }
    }

    try expect(file_count > 0);
}

test "custom iterator" {
    var iter = ConstainsIterator{
        .strings = &[_][]const u8{"one", "two", "three"},
        .needle = "e"
    };

    try expect(std.mem.eql(u8, iter.next().?, "one"));
    try expect(std.mem.eql(u8, iter.next().?, "three"));
    try expect(iter.next() == null);
}