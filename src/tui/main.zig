const args = @import("args");
const std = @import("std");
const vaxis = @import("vaxis");
const login_widget = @import("widgets/login.zig");
const Cell = vaxis.Cell;
const TextInput = vaxis.widgets.TextInput;
const border = vaxis.widgets.border;
const vxfw = vaxis.vxfw;

// ---------------------------------------------------------------------------
// Empty config struct for future extensibility via comptime.
// Pattern is obvious and future-proof: TuiConfig can be extended with fields
// without disturbing the architecture.
// ---------------------------------------------------------------------------
pub const TuiConfig = struct {};

// ---------------------------------------------------------------------------
// CLI flag setup - minimal flags per requirements.
// ---------------------------------------------------------------------------
pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("verbose", .{
        .short = 'v',
        .help = "Enable verbose output",
    });
    try parser.addOption("doctor", .{
        .short = 'd',
        .help = "dose an app health check",
        .default = "output.txt",
    });
    try parser.addFlag("debug", .{
        .short = 'g',
        .help = "Enable debug mode",
    });
}

// This can contain internal events as well as Vaxis events.
// Internal events can be posted into the same queue as vaxis events to allow
// for a single event loop with exhaustive switching. Booya
const Event = union(enum) {
    key_press: vaxis.Key,
    winsize: vaxis.Winsize,
    focus_in,
    foo: u8,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const alloc = init.arena.allocator();

    var buffer: [1024]u8 = undefined;
    var app: vxfw.App = try .init(io, alloc, init.environ_map, &buffer);
    defer app.deinit();

    // We heap allocate our model because we will require a stable pointer to it in our Button
    // widget
    var model = try alloc.create(login_widget.login);
    defer alloc.destroy(model);

    // Set the initial state of our button
    model.* = .{ .count = 0, .button = .{
        .label = "login",
        .onClick = login_widget.login.onClick,
        .userdata = model,
    }, .password = .{ .buf = .init(alloc) }, .email = .{ .buf = .init(alloc) } };

    try app.run(model.widget(), .{});
}
