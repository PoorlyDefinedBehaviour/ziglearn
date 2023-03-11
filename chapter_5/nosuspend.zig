const std = @import("std");

fn doTicksDuration(ticker: *u32) i64 {
    const start = std.time.milliTimestamp();

    while (ticker.* > 0) {
        suspend {}
        ticker.* -= 1;
    }

    return std.time.milliTimestamp() - start;
}

pub fn main() !void {
    var ticker: u32 = 0;
    const duration = nosuspend doTicksDuration(&ticker);
    std.debut.print("duration={}", .{duration});
}