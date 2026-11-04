const std = @import("std");
pub const sqlite = @import("sqlite");
const shared = @import("shared_types.zig");

// this code is for the system calls that are needed for the app
// this way we can keep all of the boundary code in one place
// this includes writing opening file and making queries to the db
pub fn gen_zooid_system_obj(comptime build_options: shared.build_options) type {
    return struct {
        io: ?std.Io = null,
        env_map: *const std.process.Environ.Map,
        writer: ?*std.Io.Writer = null,
        db: ?*sqlite.sqlite3 = null,
        db_mutex: std.Io.Mutex = .init,

        pub fn init(obj: @This()) @This() {
            var new_obj = obj;
            _ = new_obj.open_db() catch null;
            return new_obj;
        }

        pub fn deinit(self: *@This()) void {
            self.close_db();
        }

        pub fn set_writer(self: *@This(), writer: *std.Io.Writer) void {
            self.writer = writer;
        }

        pub fn get_home_dir(self: *const @This()) ![]const u8 {
            return self.env_map.get("HOME") orelse return error.HomeDirNotFound;
        }

        /// this is helper that just uses a jump to jump io if ?*std.Io.Writer is null
        pub fn print(
            self: *const @This(),
            comptime format: []const u8,
            args: anytype,
        ) void {
            // 1. Check if the optional writer is present using payload capture
            if (self.writer) |writer| {
                // 2. Format and print. Since your signature returns `void`,
                // you must explicitly handle or swallow any potential I/O errors.
                writer.print(format, args) catch {};
            }
        }

        pub fn open_db(self: *@This()) !*sqlite.sqlite3 {
            //we need an allocator so we are going to use a buffer
            var buffer: [512]u8 = undefined;
            var fba = std.heap.FixedBufferAllocator.init(&buffer);
            const allocator = fba.allocator();
            const homepath = self.get_home_dir() catch "";
            const path = "/" ++ build_options.build_dir ++ "/" ++ build_options.db_file_name ++ "\x00";
            const dir = try std.mem.concat(allocator, u8, &.{ homepath, path });
            // 1. Fast path: If already initialized globally, unwrap and return it
            if (self.db != null) {
                return @ptrCast(&self.db);
            }
            if (self.io) |io| {
                try self.db_mutex.lock(io);
                defer self.db_mutex.unlock(io);

                // 2. Setup a local, strict standard optional pointer
                var db: ?*sqlite.sqlite3 = null;

                // 3. Pass its address. Zig automatically coerces &db into the [*c]?*sqlite3 SQLite wants
                const rc = sqlite.sqlite3_open(dir.ptr, &db);

                if (rc != sqlite.SQLITE_OK) {
                    if (db) |actual_db| {
                        _ = sqlite.sqlite3_close(actual_db);
                    }
                    return error.SqliteOpenFailed;
                }

                // 4. Save to cache and return the safe Zig pointer
                self.db = db orelse return error.SqliteOpenFailed;
                return self.db.?;
            }
            return error.IoObjIsNull;
        }

        pub fn close_db(self: *@This()) void {
            if (self.db) |actual_db| {
                _ = sqlite.sqlite3_close(actual_db);
            }
        }

        pub fn login(
            self: *const @This(),
            token: [:0]const u8,
        ) void {
            // we set the env var for he password
            if (self.env_map) |env| {
                try env.put("ZOOID_TOKEN", token);
            }
        }

        pub fn exec(
            self: *@This(),
            sql: [:0]const u8,
        ) !void {
            if (self.db) |db| {
                var err_msg: [*c]u8 = null;
                const rc = sqlite.sqlite3_exec(db, sql.ptr, null, null, &err_msg);
                if (rc != sqlite.SQLITE_OK) {
                    if (err_msg) |msg| {
                        std.debug.print("[sqlite] error: {s}\n", .{std.mem.span(msg)});
                        sqlite.sqlite3_free(msg);
                    }
                    return error.SqliteExecFailed;
                }
            } else {
                return error.SqliteExecFailed;
            }
        }
    };
}
