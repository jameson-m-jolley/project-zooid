const std = @import("std");
const args = @import("args");
const Io = std.Io;

const zooid = @import("libzooid");

pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("login", .{
        .short = 'l',
        .help = "starts the login script",
    });

    try parser.addFlag("install", .{
        .short = 'i',
        .help = "installs the software",
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

    if (result.getBool("login") orelse false) {
        return .login;
    }
    if (result.getBool("install") orelse false) {
        return .install;
    }

    return .none;
}

const commands = enum {
    login,
    install,
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
        .login => {
            stdout.print("[cli] asking doctor if db exists...\n", .{}) catch unreachable;

            const res: bool = try zooid.doctor_type.check_if_db_exists(zooid_system_obj);

            if (res) {
                stdout.print("[cli] starting login...\n", .{}) catch unreachable;
                //zooid.client_type.login("jameson.m.jolley@gmail.com");
            } else {
                stdout.print("[cli] db is not found run doctor reinstall...\n", .{}) catch unreachable;
            }
        },
        .doctor => {},
        .install => {
            stdout.print("[cli] installing libzooid\n", .{}) catch unreachable;
            try zooid.doctor_type.install_zooid(zooid_system_obj);
            stdout.print("[cli] installing zooid_cli\n", .{}) catch unreachable;
        },
        .none => {},
        .err => {
            stdout.print("[cli] parrser errored\n", .{}) catch unreachable;
        },
    }

    stdout.flush() catch unreachable;
}
