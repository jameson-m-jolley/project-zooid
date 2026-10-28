const std = @import("std");
const shared = @import("shared_types.zig");

pub fn gen_voice_channels_struct(comptime build_options: shared.build_options) type {
    _ = build_options;
    return struct {
        pub const errors = error{};
        pub fn init() @This() {
            return .{};
        }
        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}

pub fn gen_channels_struct(comptime build_options: shared.build_options) type {
    _ = build_options;
    return struct {
        pub const errors = error{};

        pub fn init(allocator: std.mem.Allocator) @This() {
            _ = allocator;
            return .{};
        }
        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
