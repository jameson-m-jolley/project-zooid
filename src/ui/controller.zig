const std = @import("std");
const view = @import("view.zig");
const rl = @import("raylib");
const zooid = @import("libzooid");
extern fn glfwWaitEvents() callconv(.c) void;

pub fn gen_controller() type {
    const View = view.gen_view();
    return struct {
        view: View,
        zooid_client: zooid.client_type,
        zooid_system: zooid.system_type,
        pub fn init(allocator: std.mem.Allocator, io: std.Io, env_map: *std.process.Environ.Map) @This() {
            var ret: @This() = .{
                .view = View.init(allocator),
                .zooid_system = zooid.system_type.init(.{
                    .io = io,
                    .env_map = env_map,
                }),
                .zooid_client = zooid.client_type.init(allocator),
            };
            ret.view.goto(.login) catch {};
            return ret;
        }

        pub fn deinit(self: *@This()) void {
            self.view.deinit();
            self.zooid_client.deinit();
            self.zooid_system.deinit();
        }

        pub fn start_ui(
            controller: *@This(),
            allocator: std.mem.Allocator,
        ) anyerror!void {
            _ = allocator;

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
                controller.view.draw();

                //----------------------------------------------------------------------------------
            }
        }
    };
}
