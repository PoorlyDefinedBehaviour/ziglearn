const std = @import("std");

var timer: ?std.time.Timer = null;
fn nanotime() u64 {
    if (timer == null) {
        timer = std.time.Timer.start() catch unreachable;
    }

    return timer.?.read();
}

const Delay = struct {
    frame: anyframe,
    expires: u64
};

fn waitForTime(time_ms: u64) void {
    suspend timer_queue.add(Delay{
        .frame = @frame(),
        .expires = nanotime() + (time_ms + std.time.ns_per_ms)
    }) catch unreachable;
}

fn waitUntilAndPrint(time1: u64, time2: u64, name: []const u8) void {
    const start = nanotime();
    
    waitForTime(time1);
    std.debug.print("[{s}] it is now {} ms since start!\n", .{name, (nanotime() - start) / std.time.ns_per_ms});

    waitForTime(time2);
    std.debug.print("[{s}] it is now {} ms since start!\n", .{name, (nanotime() - start) / std.time.ns_per_ms});
}

var timer_queue: std.PriorityQueue(Delay, void, cmp) = undefined;
fn cmp(context: void, a: Delay, b: Delay) std.math.Order {
    _ = context;
    return std.math.order(a.expires, b.expires);
}

fn asyncMain() void {
    var tasks = []@Frame(waitUntilAndPrint){
        async waitUntilAndPrint(1000, 1200, "task-pair a"),
        async waitUntilAndPrint(500, 1300, "task-pair b"),
    };

    for (tasks) |*t| await t;
}

pub fn main() !void {
    timer_queue = std.PriorityQueue(Delay, void, cmp).init(std.heap.page_allocator, undefined);
    defer timer_queue.deinit();

    var main_task = async asyncMain();

    while(timer_queue.removeOrNull()) |delay| {
        const now = nanotime();
        if (now < delay.expires) {
            std.time.sleep(delay.expires - now);
        }

        resume delay.frame;
    }

    nosuspend await main_task;
}