const std = @import("std");
const main_dashbord = @import("main_dashbord.zig");
const login = @import("login.zig");
const settings = @import("settings.zig");
const view = @import("view.zig");

pub const views = enum {
    login,
    main,
    settings,
};

pub fn gen_view() type {
    const ViewList = std.ArrayList(views);
    return struct {
        view_stack: ViewList,
        allocator: std.mem.Allocator,
        main_dash: main_dashbord.MainDashbord,
        login_gui: login.LoginGui,
        settings_gui: settings.SettingsGui,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .view_stack = ViewList.empty,
                .allocator = allocator,
                .main_dash = main_dashbord.MainDashbord.init(allocator, 1920, 1080),
                .login_gui = login.LoginGui.init(allocator),
                .settings_gui = settings.SettingsGui.init(allocator),
            };
        }

        pub fn deinit(self: *@This()) void {
            self.view_stack.deinit(self.allocator);
            self.main_dash.deinit();
            self.login_gui.deinit();
            self.settings_gui.deinit();
        }

        pub fn draw(self: *@This()) void {
            if (self.current()) |v| {
                switch (v) {
                    views.login => self.login_gui.draw(self),
                    views.main => self.main_dash.draw(),
                    views.settings => self.settings_gui.draw(),
                }
            }
        }

        /// Navigate forward to a view, pushing it onto the stack.
        pub fn goto(self: *@This(), v: views) !void {
            try self.view_stack.append(self.allocator, v);
        }

        /// Navigate backward, popping the last view off the stack.
        /// Returns false if the stack is empty.
        pub fn back(self: *@This()) bool {
            if (self.view_stack.items.len == 0) return false;
            if (self.view_stack.pop()) |_| {
                return true;
            }
            return false;
        }

        /// The current (topmost) view on the stack, or null if empty.
        pub fn current(self: *@This()) ?views {
            if (self.view_stack.items.len == 0) return null;
            return self.view_stack.items[self.view_stack.items.len - 1];
        }
    };
}
