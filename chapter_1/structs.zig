const expect = @import("std").testing.expect;

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32
};

const Vec4 = struct {
    x: f32,
    y: f32,
    z: f32 = 0,
    w: f32 = undefined,
};

const Stuff = struct {
    x: i32,
    y: i32,
    fn swap(self: *Stuff) void {
        // self.field is derefences the pointer to Stuff automatically.
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };

    _ = my_vector;
}

test "missing struct field won't compile" {
    const my_vector = Vec3 {
        .x = 0,
        .z = 50,
    };

    _ = my_vector;
}

test "struct fields may be given default values" {
    const my_vector = Vec4 {
        .x = 25,
        .y = -50,
    };

    _ = my_vector;
}

test "structs can have methods, one level pointers to structs are automatically dereferenced" {
    var thing = Stuff {. x = 10, . y = 20};
    thing.swap();
    try expect(thing.x == 20);
    try expect(thing.y == 10);
}