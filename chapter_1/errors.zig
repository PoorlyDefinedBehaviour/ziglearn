const print = @import("std").debug.print;
const expect = @import("std").testing.expect;

// An error set is like an enum, where each error in the set is a value. 
// There are no exceptions in Zig.
const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound
};

const AllocationError = error{
    // This error is in the FileOpenError set.
    OutOfMemory
};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_error: AllocationError ! u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn failingFunction() error{Oops} ! void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
    };
}

// try x is a shortcut for x catch |err| return err
fn failFn() error{Oops} ! i32 {
    try failingFunction();
    return 12;
}

test "try" {
    var v = failFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };

    // This is never reached because of the return statement.
    try expect(v == 12);
}

// errdefer works like defer, but only executes when the function is returned from
// with an error inside of the errdefer's block.
var problems: u32 = 98;

fn failFnCounter() error{Oops} ! void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

// Error unions returned from a function can have their error sets inferred by
// not having an explicit error set. This inferred error set contains all possible
// errors which the function may returned.
fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    const x: error{AccessDenied} ! void = createFile();

    _ = x catch {};
}

test "error sets can be merged" {
    const A = error{NotDir, PathNotFound};
    const B = error{OutOfMemory, PathNotFound};
    const C = A || B;
    try expect(C == error{NotDir, OutOfMemory, PathNotFound});
}