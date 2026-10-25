const std = @import("std");
const rl = @import("raylib");
const util = @import("root.zig");


pub const global_buffer_size = 5000;
pub var global_draw_que = SOA_draw_type(global_buffer_size).init();

///this is to make the functionally that generalizes to all of the draw functions
/// this is paired with an enum so that we can draw the world with this que making our game logic
/// more clean and robust
/// this give us options
/// (z+y) :> (entities)
/// (min f32) :> (ground)
/// (z + min f32+1) :> (buildings)
/// this locks the buildings and the ground to the foreground
fn get_z_offset_from_options(z: f32, y: f32, option: DrawOption) f32 {
    switch (option) {
        .buildings => {
            return z - std.math.inf(f32) + 1;
        },
        .ground => {
            return -std.math.inf(f32);
        },
        .entity => {
            return z + y;
        },
        else => {
            unreachable;
        },
    }
}

pub const DrawOption = enum(u8) {
    ground = 0,
    buildings = 1,
    entity = 2,
    player = 3,
    none = 4,
    absolute = 5,
    absolute_text = 6,
    text = 7,
};

/// this should be a heep that removes all elements after a draw call
pub fn SOA_draw_type(comptime size: usize) type {
    comptime var fixed_size = size;
    inline for (0..8) |_| {
        if (comptime size % 8 == 0) {
            fixed_size = size + 1;
        }
    }

    return struct {
        option: [fixed_size]u8,
        texture: [fixed_size]?*const [9:0]u8,
        //offsets
        currentFrameX: [fixed_size]f32,
        currentFrameY: [fixed_size]f32,
        currentFrameWidth: [fixed_size]f32,
        currentFrameHight: [fixed_size]f32,
        //destination rectangle for drawing
        destinationWidth: [fixed_size]f32,
        destinationHight: [fixed_size]f32,

        ///color
        r: [fixed_size]u8,
        g: [fixed_size]u8,
        b: [fixed_size]u8,
        a: [fixed_size]u8,
        /// vector math
        x: [fixed_size]f32,
        y: [fixed_size]f32,
        z: [fixed_size]f32,
        theta: [fixed_size]f32,
        size: usize = 0,
        pub fn init() @This() {
            return .{
                .option = .{0} ** fixed_size,
                .texture = .{null} ** fixed_size,
                .currentFrameX = .{0} ** fixed_size,
                .currentFrameY = .{0} ** fixed_size,
                .currentFrameWidth = .{0} ** fixed_size,
                .currentFrameHight = .{0} ** fixed_size,
                .destinationWidth = .{0} ** fixed_size,
                .destinationHight = .{0} ** fixed_size,
                .r = .{0} ** fixed_size,
                .g = .{0} ** fixed_size,
                .b = .{0} ** fixed_size,
                .a = .{0} ** fixed_size,
                .x = .{0} ** fixed_size,
                .y = .{0} ** fixed_size,
                .z = .{0} ** fixed_size,
                .theta = .{0} ** fixed_size,
            };
        }

        fn get_context_vec(self: *const @This()) [fixed_size]f32 {
            var ret: [fixed_size]f32 = [_]f32{0} ** fixed_size;
            var i: usize = 0;
            for (self.z[0..fixed_size], self.y[0..fixed_size], self.option[0..fixed_size]) |z, y, option| {
                switch (option) {
                    @intFromEnum(DrawOption.ground) => {
                        ret[i] = -std.math.inf(f32);
                    },
                    else => {
                        ret[i] = z + y;
                    },
                }
                i = i + 1;
            }
            return ret;
        }

        fn cmp_eli(context: *const [fixed_size]f32, lhs: usize, rhs: usize) bool {
            return context[lhs] < context[rhs];
        }

        fn get_current_frame(self: *const @This(), index: usize) rl.Rectangle {
            return rl.Rectangle.init(self.currentFrameX[index], self.currentFrameY[index], self.currentFrameWidth[index], self.currentFrameHight[index]);
        }

        fn get_entity_position(self: *const @This(), index: usize) rl.Vector2 {
            return rl.Vector2.init(self.x[index], self.y[index]);
        }
        fn get_offset(self: *const @This(), index: usize, offsetVec: rl.Vector2) rl.Vector2 {
            return rl.math.vector2Subtract(self.get_entity_position(index), offsetVec);
        }

        fn get_destination(self: *const @This(), index: usize) rl.Rectangle {
            return rl.Rectangle.init(self.x[index], self.y[index], self.destinationWidth[index], self.destinationHight[index]);
        }

        fn get_color(self: *const @This(), index: usize) rl.Color {
            return rl.Color.init(self.r[index], self.g[index], self.b[index], self.a[index]);
        }

        pub fn draw(self: *@This(), Model: *mod.newModel()) void {
            // set the size to 0 so we can reuse the draw queue after we draw everything
            defer self.size = 0;
            // we sort by an index then we draw in order
            // 1. The original unsorted data
            const data = self.get_context_vec();

            // 2. The index array we want to sort
            var indexes: [fixed_size]usize = undefined;
            for (0..fixed_size) |i| {
                indexes[i] = i;
            }
            // 3. Sort the indexes. We pass 'data' as the context.
            std.mem.sort(usize, &indexes, &data, cmp_eli);
            for (indexes) |i| {
                defer self.texture[i] = null;
                // set the texture to null so it is impossible to draw the same texture twice
                // in one frame this is not a hack it is for correctness

                if (self.texture[i]) |texturekey| {
                    switch (@as(DrawOption, @enumFromInt(self.option[i]))) {
                        DrawOption.text => {},
                        DrawOption.player => {
                            if (lazy_load_texture(Model, texturekey)) |texture| {
                                rl.drawTexturePro(
                                    texture.*,
                                    self.get_current_frame(i),
                                    self.get_destination(i),
                                    rl.Vector2.init(0, 0),
                                    self.theta[i],
                                    self.get_color(i),
                                );
                            }
                        },
                        DrawOption.entity => {
                            if (lazy_load_texture(Model, texturekey)) |texture| {
                                rl.drawTexturePro(
                                    texture.*,
                                    self.get_current_frame(i),
                                    self.get_destination(i),
                                    rl.Vector2.init(0, 0),
                                    self.theta[i],
                                    self.get_color(i),
                                );
                            }
                        },
                        DrawOption.absolute => {},
                        DrawOption.absolute_text => {},
                        DrawOption.ground => {
                            if (lazy_load_texture(Model, texturekey)) |texture| {
                                rl.drawTexturePro(
                                    texture.*,
                                    self.get_current_frame(i),
                                    self.get_destination(i),
                                    rl.Vector2.init(0, 0),
                                    self.theta[i],
                                    self.get_color(i),
                                );
                            }
                        },
                        DrawOption.none => {},
                        DrawOption.buildings => {},
                    }
                }
            }
        }
        /// this is a simd insertion sort
        /// this should be very very fast
        /// we are not using a heep simply for the  that simd is faster
        pub fn add_draw_call(
            self: *@This(),
            option: u8,
            texture: ?*const [9:0]u8,
            //offsets
            currentFrameX: f32,
            currentFrameY: f32,
            currentFrameWidth: f32,
            currentFrameHight: f32,
            destinationWidth: f32,
            destinationHight: f32,
            ///color
            r: u8,
            g: u8,
            b: u8,
            a: u8,
            /// vector math
            x: f32,
            y: f32,
            z: f32,
            theta: f32,
        ) !void {
            if (self.size > fixed_size) {
                @panic("no more size in the draw que!!! you need more memory in the build");
            } else {
                self.option[self.size] = option;
                self.texture[self.size] = texture;
                self.currentFrameX[self.size] = currentFrameX;
                self.currentFrameY[self.size] = currentFrameY;
                self.currentFrameWidth[self.size] = currentFrameWidth;
                self.currentFrameHight[self.size] = currentFrameHight;
                self.r[self.size] = r;
                self.g[self.size] = g;
                self.b[self.size] = b;
                self.a[self.size] = a;
                self.destinationWidth[self.size] = destinationWidth;
                self.destinationHight[self.size] = destinationHight;
                self.x[self.size] = x;
                self.y[self.size] = y;
                self.z[self.size] = z;
                self.theta[self.size] = theta;
            }
            self.size = self.size + 1;
        }
    };
}

// 1. Define your map at container-level using comptime initialization
const spritesheet_table = std.StaticStringMap([:0]const u8).initComptime(.{
    .{ "projec   ", "src/assets/Spritesheet/All_Fire_Bullet_Pixel_16x16.png" },
    .{ "world    ", "src/assets/Spritesheet/roguelikeSheet_transparent.png" },
    .{ "player   ", "src/assets/Spritesheet/player.png" },
});

fn lazy_load_texture(Model: *mod.newModel(), texture_key: *const [9:0]u8) ?*const rl.Texture2D {
    if (Model.Textures2D.get(texture_key)) |texture| {
        return &texture;
    } else {
        defer std.debug.print("INFO: lazy loading texture: {s}\n", .{texture_key});
        //find in the spritesheet_table
        if (spritesheet_table.get(texture_key)) |found| {
            const texture = rl.loadTexture(found) catch return null;
            Model.Textures2D.put(texture_key, texture) catch @panic("failed to put texture in model most likely out of memory try closing some other programs");
            return &texture;
        } else {
            defer std.debug.print("ERROR: texture not found in spritesheet_table: {s}\n", .{texture_key});
            return null;
        }
    }
}
