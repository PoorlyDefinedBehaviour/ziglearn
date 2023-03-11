const expect = @import("std").testing.expect;

const Direction = enum { north, south, east, west };

const Value = enum(u2) { zero, one, two };

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    // Starts at million + 1.
    next,
};

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

const Mode = enum {
    // Acts like a namespaced global.
    // Could be const.
    var count: u32 = 0;
    on,
    off
};

test "enum ordinal values start at 0" {
    try expect(@enumToInt(Direction.north) == 0);
    try expect(@enumToInt(Direction.south) == 1);
    try expect(@enumToInt(Direction.east) == 2);
    try expect(@enumToInt(Direction.west) == 3);
    try expect(@enumToInt(Value.zero) == 0);
    try expect(@enumToInt(Value.one) == 1);
    try expect(@enumToInt(Value.two) == 2);
}

test "enum values can be overriden" {
    try expect(@enumToInt(Value2.next) == 1000001);
}

test "enums can have methods" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

test "enums can have var and const declarations" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}