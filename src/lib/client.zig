const friends = @import("friends.zig");
const communities = @import("communities.zig");
const shared = @import("shared_types.zig");
const system = @import("system.zig");
const std = @import("std");

pub fn gen_zooid_client_struct(comptime build_options: shared.build_options) type {
    return struct {
        pub const errors = error{}; // or this?
        port: u16,
        protocol: shared.email_protocol,
        user_email: ?*const [:0]u8,
        user_token: ?*const [:0]u8,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .port = 2342,
                .protocol = .IMAP,
                .user_email = null,
                .user_token = null,
                .allocator = allocator,
            };
        }

        pub fn deinit(this: *@This()) void {
            _ = this;
        }

        pub fn login(self: *@This(), system_call_obj: system.gen_zooid_system_obj(build_options)) void {
            if (self.email) |_| {
                system_call_obj.print("[zooid] logging in with email {s}", .{});
            }
        }
    };
}
