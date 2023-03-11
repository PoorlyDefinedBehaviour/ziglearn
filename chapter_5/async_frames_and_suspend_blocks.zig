const std = @import("std");
const expect = std.testing.expect;

fn add(a: i32, b: i32) i64 {
    return a + b;
}

fn double(value: u8) u9 {
    suspend {
        resume @frame();
    }
    return value * 2;
}

test "@Frame" {
    var frame: @Frame(add) = async add(1, 2);
    try expect(await frame == 3);
}

test "@frame 1" {
    var f = async double(1);
    try expect(nosuspend await f == 2);
}

// Waking a function up.
fn callLater(comptime laterFn: fn() void , ms: u64) void {
    suspend {
        wakeUpLater(@frame(), ms);
    }
    laterFn();
}

fn wakeUpLater(frame: anyframe, ms: u64) void {
    std.time.sleep(ms * std.time.ns_per_ms);
    resume frame;
}

fn alarm() void {
    std.debug.print("Time's Up!\n", .{});
}

test "@frame 2" {
    nosuspend callLater(alarm, 1000);
}

// anyframe->T
fn zero(comptime x: anytype) x {
    return 0;
}

fn awaiter(x: anyframe->f32) f32 {
    return nosuspend await x;
}

test "anyframe->T" {
    var frame = async zero(f32);
    try expect(awaiter(&frame) == 0);
}