const std = @import("std");
const view = @import("view.zig");
const rl = @import("raylib");
const zooid = @import("libzooid");
const settings = @import("settings.zig");
//extern fn glfwWaitEvents() callconv(.c) void;
extern fn glfwWaitEventsTimeout(timeout: f64) callconv(.c) void;

pub fn gen_controller() type {
    const View = view.gen_view();
    return struct {
        view: View,
        zooid_client: zooid.client_type,
        zooid_system: zooid.system_type,
        ruining: bool = true,
        interaction_counter: u8 = 5, // Counter for user interaction, starts at
        settings: settings.settings = .{
            .cpu_throttle = 0,
            .ui_update_interval = 10.0,
        },

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

        pub fn interaction_update(self: *@This()) void {
            //std.debug.print("Interaction detected, resetting counter to 5\n", .{});
            self.interaction_counter = 5; // Reset the interaction counter to 255 on user interaction
        }

        pub fn interaction_tick(self: *@This()) void {
            //std.debug.print("Interaction tick, current counter: {}\n", .{self.interaction_counter});
            if (self.interaction_counter > 0) {
                self.interaction_counter -= 1; // Decrement the interaction counter if it's greater than 0
            }
        }

        pub fn is_interacting(self: *@This()) bool {
            self.interaction_tick(); // Call interaction_tick to update the counter
            return self.interaction_counter > 0; // Return true if the interaction counter is greater than 0
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
            while (!rl.windowShouldClose() and controller.ruining) { // Detect window close button or ESC key
                // Update
                //----------------------------------------------------------------------------------
                // TODO: Update your variables here
                //----------------------------------------------------------------------------------

                // Draw
                //----------------------------------------------------------------------------------

                if (!controller.is_interacting()) {
                    // If no interaction, we can perform background tasks or updates
                    // For example, we could check for new messages or perform periodic updates
                    glfwWaitEventsTimeout(controller.settings.ui_update_interval); // Wait for events with a timeout of 10 seconds
                    // we are now in the part of the code where we know an interaction has happened, so we can reset the interaction counter
                    controller.interaction_update();
                }

                rl.clearBackground(.white);
                rl.beginDrawing();
                defer rl.endDrawing();
                controller.ruining = controller.view.draw();
                // Replace std.Thread.sleep with this:

                // if on this may cause stuttering but this is a user preference,
                //so we can make it a setting in the future,
                //but for now, we will just use a hardcoded value of 10ms,
                //which is a good balance between responsiveness and CPU usage
                if (controller.settings.cpu_throttle > 0) {
                    var ts = std.posix.timespec{ .sec = 0, .nsec = controller.settings.cpu_throttle * std.time.ns_per_ms };
                    _ = std.posix.system.nanosleep(&ts, &ts);
                }

                //----------------------------------------------------------------------------------
            }
        }
    };
}
