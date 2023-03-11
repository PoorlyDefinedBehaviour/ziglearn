const std = @import("std");
const expect = std.testing.expect;

const Place = struct {lat: f32, long: f32};

test "json parse" {
    var stream = std.json.TokenStream.init("{ \"lat\": 40.684540, \"long\": -74.401422 }");

    const x = try std.json.parse(Place, &stream, .{});

    try expect(x.lat == 40.684540);
    try expect(x.long == -74.401422);
}

test "json stringify" {
    const x = Place{
        .lat = 51.997664,
        .long = -0.740687
    };

    var buf: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    var string = std.ArrayList(u8).init(fba.allocator());
    try std.json.stringify(x, .{}, string.writer());
    
    try expect(std.mem.eql(u8, string.items,  "{\"lat\":5.19976654e+01,\"long\":-7.40687012e-01}"));
}