const std = @import("std");
const vaxis = @import("vaxis");
const vxfw = vaxis.vxfw;

const focused = enum {
    email,
    password,
};

pub const login = struct {
    count: u32 = 0,
    button: vxfw.Button,
    email: vxfw.TextField,
    password: vxfw.TextField,
    focused: enum { email, password } = .email,

    pub fn widget(self: *login) vxfw.Widget {
        return .{
            .userdata = self,
            .eventHandler = login.typeErasedEventHandler,
            .drawFn = login.typeErasedDrawFn,
        };
    }

    fn typeErasedEventHandler(ptr: *anyopaque, ctx: *vxfw.EventContext, event: vxfw.Event) anyerror!void {
        const self: *login = @ptrCast(@alignCast(ptr));

        switch (event) {
            .mouse => |mouse| {
                if (mouse.type == .press and mouse.button == .left) {
                    // click this field to focus it
                    return ctx.requestFocus(self.widget());
                }
                return ctx.consumeEvent();
            },
            .init => return ctx.requestFocus(self.email.widget()),
            .key_press => |key| {
                if (key.matches('c', .{ .ctrl = true })) {
                    ctx.quit = true;
                    return;
                }
                if (key.matches(vaxis.Key.tab, .{})) {
                    switch (self.focused) {
                        .email => {
                            self.focused = .password;
                            try ctx.requestFocus(self.password.widget());
                        },
                        .password => {
                            self.focused = .email;
                            try ctx.requestFocus(self.email.widget());
                        },
                    }
                }

                switch (self.focused) {
                    .email => {
                        self.email.handleEvent(ctx, .{ .key_press = key }) catch {};

                        return;
                    },
                    .password => {
                        self.password.handleEvent(ctx, .{ .key_press = key }) catch {};

                        return;
                    },
                }

                // for a simple login form, route keys to the email field

            },
            .focus_out, .focus_in => ctx.redraw = true,
            else => {},
        }
    }

    fn typeErasedDrawFn(ptr: *anyopaque, ctx: vxfw.DrawContext) std.mem.Allocator.Error!vxfw.Surface {
        const self: *login = @ptrCast(@alignCast(ptr));
        const max_size = ctx.max.size();
        const cx = max_size.width / 2;
        const cy = max_size.height / 2;

        const email_box: vxfw.Border = .{
            .child = self.email.widget(),
            .style = .{
                .fg = .{ .rgb = [_]u8{ 200, 200, 200 } },
            },
            .labels = &[_]vxfw.Border.BorderLabel{
                .{ .text = "Email", .alignment = .top_left },
            },
        };

        const password_box: vxfw.Border = .{
            .child = self.password.widget(),
            .style = .{
                .fg = .{ .rgb = [_]u8{ 200, 200, 200 } },
            },
            .labels = &[_]vxfw.Border.BorderLabel{
                .{ .text = "Password", .alignment = .top_left },
            },
        };

        const email_child: vxfw.SubSurface = .{
            .origin = .{ .row = cy - 2, .col = cx - 12 },
            .surface = try email_box.draw(ctx.withConstraints(
                ctx.min,
                .{ .width = 24, .height = 3 },
            )),
        };

        const password_child: vxfw.SubSurface = .{
            .origin = .{ .row = cy + 2, .col = cx - 12 },
            .surface = try password_box.draw(ctx.withConstraints(
                ctx.min,
                .{ .width = 24, .height = 3 },
            )),
        };

        const button_child: vxfw.SubSurface = .{
            .origin = .{ .row = cy + 8, .col = cx - 6 },
            .surface = try self.button.draw(ctx.withConstraints(
                ctx.min,
                .{ .width = 12, .height = 1 },
            )),
        };

        const children = try ctx.arena.alloc(vxfw.SubSurface, 3);
        children[0] = email_child;
        children[1] = password_child;
        children[2] = button_child;

        return .{
            .size = max_size,
            .widget = self.widget(),
            .buffer = &.{},
            .children = children,
        };
    }

    pub fn onClick(maybe_ptr: ?*anyopaque, ctx: *vxfw.EventContext) anyerror!void {
        const ptr = maybe_ptr orelse return;
        const self: *login = @ptrCast(@alignCast(ptr));
        self.count +|= 1;
        return ctx.consumeAndRedraw();
    }
};
