const std = @import("std");
const args = @import("args");
const rl = @import("raylib");
const main_v = @import("main_dashbord.zig");
const login_v = @import("login.zig");
const settings_v = @import("settings.zig");
extern fn glfwWaitEvents() callconv(.c) void;

const Io = std.Io;

const zooid = @import("libzooid");

pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("start", .{
        .short = 's',
        .help = "starts the ui",
    });

    try parser.addSubcommand(.{
        .name = "doctor",
        .help = "app health check",
        .args = &[_]args.ArgSpec{
            .{
                .name = "in path?",
                .long = "is_in_env",
                .help = "can os call zooid_cli?",
                .action = .store_true,
            },
            .{
                .name = "DB exists?",
                .long = "check_DB",
                .help = "os has DB installed?",
                .action = .store_true,
            },
        },
    });

    try parser.addSubcommand(.{ .name = "install", .help = "installs app" });
}

fn make_switch_enum(init: std.process.Init, parser: *args.ArgumentParser) !commands {
    var result = try parser.parseProcess(init);
    defer result.deinit();

    if (result.getBool("doctor") orelse false) {
        return .doctor;
    }
    if (result.getBool("start") orelse false) {
        return .start;
    }

    return .none;
}

const commands = enum {
    start,
    doctor,
    err,
    none,
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    var zooid_client: zooid.client_type = zooid.client_type.init(allocator);
    defer zooid_client.deinit();

    const io = init.io;
    // Allocate a buffer on the stack for stdout streaming
    var stdout_buffer: [1024]u8 = undefined;
    // Pass the file instance, io handle, and the output buffer
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var zooid_system_obj: zooid.system_type = zooid.system_type.init(.{
        .writer = stdout,
        .env_map = init.environ_map,
        .io = io,
    });
    defer zooid_system_obj.deinit();

    // Create argument parser
    var parser = try args.ArgumentParser.init(allocator, .{
        .name = "zooid_CLI",
        .version = "0.0.1",
        .description = "Privacy-first messaging layer to replace Discord/Slack: end-to-end encrypted, metadata-minimizing, \npeer-to-peer/federated transports with no centralized hosting or data harvesting for AI training",
    });
    defer parser.deinit();

    try set_up_flags(&parser);

    // Parse command-line arguments from the process init context
    // var result = try parser.parseProcess(init);
    // defer result.deinit();
    switch (make_switch_enum(init, &parser) catch .err) {
        .start => {
            try start_ui(allocator);
        },
        .doctor => {},
        .none => {},
        .err => {
            stdout.print("[cli] parrser errored\n", .{}) catch unreachable;
        },
    }

    stdout.flush() catch unreachable;
}

pub fn start_ui(allocator: std.mem.Allocator) anyerror!void {

    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1920;
    const screenHeight = 1080;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(0); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        glfwWaitEvents();
        rl.clearBackground(.white);
        rl.beginDrawing();
        defer rl.endDrawing();
        var main_dash = main_v.MainDashbord.init(
            allocator,
            screenWidth,
            screenHeight,
        );
        defer main_dash.deinit();
        var login_gui = login_v.LoginGui.init(allocator);
        defer login_gui.deinit();
        var settings_gui = settings_v.SettingsGui.init(allocator);
        defer settings_gui.deinit();
        main_dash.draw();
        login_gui.draw();
        settings_gui.draw();

        //----------------------------------------------------------------------------------
    }
}
