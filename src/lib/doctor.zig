const std = @import("std");
const shared = @import("shared_types.zig");
const sqlite = @import("sqlite");
const system = @import("system.zig");
pub fn gen_doctor_struct(comptime build_options: shared.build_options) type {
    return struct {
        pub const errors = error{
            no_io,
        };

        pub fn init(allocator: std.mem.Allocator) @This() {
            _ = allocator;
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }

        pub fn check_if_db_exists(system_call_obj: system.gen_zooid_system_obj(build_options)) !bool {
            const home = try system_call_obj.get_home_dir();
            if (system_call_obj.io) |io| {
                system_call_obj.print("[doctor] looking for the home dir\n", .{});
                var home_dir = std.Io.Dir.cwd().openDir(io, home, .{}) catch {
                    system_call_obj.print("[doctor] failed looking for the home dir\n", .{});
                    return false;
                };
                //#1 look if ~/doctor_build_options.build_dir is on the system
                system_call_obj.print("[doctor] looking for the {s} dir\n", .{build_options.build_dir});
                var dir = home_dir.openDir(io, build_options.build_dir, .{}) catch {
                    system_call_obj.print("[doctor] failed looking for the build dir (eg -> ~/{s}) \n", .{build_options.build_dir});
                    return false;
                };
                defer dir.close(io);
                defer home_dir.close(io);

                //#2 look if ~/.doctor_build_options.build_dir/db_file_name.db is there
                system_call_obj.print("[doctor] looking for .db file\n", .{});
                const file = dir.openFile(io, build_options.db_file_name, .{}) catch |err| {
                    if (err == error.FileNotFound) {
                        system_call_obj.print("[doctor] dir exists but DB was removed or never created\n", .{});
                        return false;
                    } else {
                        system_call_obj.print("[doctor] dir exists but I can't tell you what is wrong plz go to https://github.com/jameson-m-jolley/project-zooid and submit a issue and get help\n\x00", .{});
                        return false;
                    }
                };
                _ = file;
            } else {
                return errors.no_io;
            }
            //#3 validate schema
            system_call_obj.print("[doctor] DB was found checking schema \n", .{});

            //#4 if all the other work then return true.
            return true;
        }

        pub fn install_zooid(system_call_obj: system.gen_zooid_system_obj(build_options)) !void {
            system_call_obj.print("[doctor] creating ~/{s}/{s} dir\n", .{ build_options.build_dir, build_options.db_file_name });
            const home_path = try system_call_obj.get_home_dir();
            if (system_call_obj.io) |io| {
                var home_dir = try std.Io.Dir.cwd().openDir(io, home_path, .{});
                defer home_dir.close(io);
                var config_dir = try home_dir.createDirPathOpen(io, build_options.build_dir, .{});
                defer config_dir.close(io);
                var db_file = try config_dir.createFile(io, build_options.db_file_name, .{});
                defer db_file.close(io);
                // curl version into if not pulled from github

                // load and install schema

            } else {
                return errors.no_io;
            }
        }
    };
}
