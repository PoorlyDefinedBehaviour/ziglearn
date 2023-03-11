const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const step = b.step("task", "do something");
    step.makeFn = myTask;
    b.default_step = step;
}

fn myTask(self: *std.builder.Step) !void {
    std.debug.print("Hello!\n", .{});
    _ = self;
}