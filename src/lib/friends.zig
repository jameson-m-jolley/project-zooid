const std = @import("std");
const shared = @import("shared_types.zig");

pub fn gen_friends_struct(comptime build_options: shared.build_options) type {
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

        pub fn install_schema(system_call_obj: shared.system_call_obj) void {
            system_call_obj.print("[lib] creating table friends\n", .{});
            const query = "CREATE TABLE IF NOT EXISTS friends (id INTEGER PRIMARY KEY AUTOINCREMENT,nickname TEXT, email TEXT);";
            _ = query;
        }
    };
}
