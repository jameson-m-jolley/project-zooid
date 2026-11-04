const std = @import("std");
const raylib = @import("raylib");
const raygui = @import("raygui");
const Vector2 = @import("raylib").Vector2;
const Rectangle = @import("raylib").Rectangle;
const controller = @import("controller.zig");
const view = @import("view.zig");

// Static text values never change, so they live as package-level consts

pub const LoginGui = struct {
    anchor01: Vector2,
    anchor02: Vector2,

    window_box_000_active: bool,
    text_box_002_edit_mode: bool,
    text_box_005_edit_mode: bool,
    text_box_002_text: [128:0]u8,
    text_box_005_text: [128:0]u8,

    scroll_panel_009_scroll_view: Rectangle,
    scroll_panel_009_scroll_offset: Vector2,
    scroll_panel_009_bounds_offset: Vector2,

    layout_recs: [10]Rectangle,

    pub fn init(allocator: std.mem.Allocator) LoginGui {
        _ = allocator;
        var self: LoginGui = undefined;

        // Init anchors
        self.anchor01 = Vector2{ .x = @floatFromInt(@divTrunc(raylib.getScreenWidth(), 2)), .y = @floatFromInt(@divTrunc(raylib.getScreenHeight(), 2)) };
        self.anchor02 = Vector2{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 176 };

        // Init control variables
        self.window_box_000_active = true;
        self.text_box_002_edit_mode = false;
        self.text_box_005_edit_mode = false;

        //you can use @splat to initialize the text buffers to all zeros, which is important for raygui.textBox to work correctly
        self.text_box_002_text = @splat('\x00'); // Initialize to all zeros
        self.text_box_005_text = @splat('\x00'); // Initialize to all zeros

        // Set initial text values
        _ = std.mem.copySentinel(u8, 0, self.text_box_002_text[0..], "email");
        _ = std.mem.copySentinel(u8, 0, self.text_box_005_text[0..], "password");
        // Mutable buffers so raygui.textBox can write keystrokes into them

        // Init scroll panel state
        self.scroll_panel_009_scroll_view = Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };
        self.scroll_panel_009_scroll_offset = Vector2{ .x = 0, .y = 0 };
        self.scroll_panel_009_bounds_offset = Vector2{ .x = 0, .y = 0 };

        // Init layout rectangles (matching gui_layout_name.h exactly, no scaling)
        self.layout_recs = undefined;

        self.layout_recs[0] = Rectangle{ .x = self.anchor01.x + 0, .y = self.anchor01.y + 0, .width = 448, .height = 360 }; // WindowBox: WindowBox000
        self.layout_recs[1] = Rectangle{ .x = self.anchor01.x + 368, .y = self.anchor01.y + 128, .width = 64, .height = 48 }; // Button: Button001
        self.layout_recs[2] = Rectangle{ .x = self.anchor01.x + 104, .y = self.anchor01.y + 40, .width = 328, .height = 32 }; // TextBox: TextBox002
        self.layout_recs[3] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 40, .width = 96, .height = 32 }; // LabelButton: LabelButton003
        self.layout_recs[4] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 88, .width = 96, .height = 32 }; // LabelButton: LabelButton004
        self.layout_recs[5] = Rectangle{ .x = self.anchor01.x + 104, .y = self.anchor01.y + 88, .width = 328, .height = 32 }; // TextBox: TextBox005
        self.layout_recs[6] = Rectangle{ .x = self.anchor01.x + 296, .y = self.anchor01.y + 128, .width = 64, .height = 48 }; // Button: Button007
        self.layout_recs[7] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 128, .width = 120, .height = 24 }; // Label: Label009
        self.layout_recs[8] = Rectangle{ .x = self.anchor02.x + 0, .y = self.anchor02.y + 16, .width = 432, .height = 160 }; // GroupBox: GroupBox008
        self.layout_recs[9] = Rectangle{ .x = self.anchor02.x + 8, .y = self.anchor02.y + 24, .width = 416, .height = 144 }; // ScrollPanel: ScrollPanel009

        return self;
    }

    pub fn deinit(self: LoginGui) void {
        _ = self;
    }

    pub fn draw(self: *LoginGui, c: *controller.gen_controller()) void {
        const WindowBox000Text: [:0]const u8 = "login"; // WINDOWBOX: WindowBox000
        const Button001Text: [:0]const u8 = "login"; // BUTTON: Button001
        const LabelButton003Text: [:0]const u8 = "email"; // LABELBUTTON: LabelButton003
        const LabelButton004Text: [:0]const u8 = "password"; // LABELBUTTON: LabelButton004
        const Button007Text: [:0]const u8 = "clear"; // BUTTON: Button007
        const Label009Text: [:0]const u8 = ""; // LABEL: Label009
        const GroupBox008Text: [:0]const u8 = "console"; // GROUPBOX: GroupBox008
        var ScrollPanel009Text: ?[*:0]const u8 = null;

        if (self.window_box_000_active) {
            self.window_box_000_active = !(raygui.windowBox(self.layout_recs[0], WindowBox000Text) > 0);
            if (raygui.button(self.layout_recs[1], Button001Text)) {
                c.view.goto(.main) catch {
                    ScrollPanel009Text = "err going to main.";
                };
            } // Button001 logic
            if (raygui.textBox(self.layout_recs[2], &self.text_box_002_text, self.text_box_002_edit_mode)) self.text_box_002_edit_mode = !self.text_box_002_edit_mode;
            if (raygui.labelButton(self.layout_recs[3], LabelButton003Text)) {} // LabelButton003 logic
            if (raygui.labelButton(self.layout_recs[4], LabelButton004Text)) {} // LabelButton004 logic
            if (raygui.textBox(self.layout_recs[5], &self.text_box_005_text, self.text_box_005_edit_mode)) self.text_box_005_edit_mode = !self.text_box_005_edit_mode;
            if (raygui.button(self.layout_recs[6], Button007Text)) {
                self.text_box_002_text = @splat('\x00'); // Clear the email text box
                self.text_box_005_text = @splat('\x00'); // Clear the password text box
            } // Button007 logic
            _ = raygui.label(self.layout_recs[7], Label009Text);
            _ = raygui.groupBox(self.layout_recs[8], GroupBox008Text);
            _ = raygui.scrollPanel(self.layout_recs[9], ScrollPanel009Text, self.layout_recs[9], &self.scroll_panel_009_scroll_offset, &self.scroll_panel_009_scroll_view);
            {
                const startX: f32 = self.scroll_panel_009_scroll_view.x + self.scroll_panel_009_scroll_offset.x;
                const startY: f32 = self.scroll_panel_009_scroll_view.y + self.scroll_panel_009_scroll_offset.y;
                raylib.beginScissorMode(
                    @intFromFloat(self.scroll_panel_009_scroll_view.x),
                    @intFromFloat(self.scroll_panel_009_scroll_view.y),
                    @intFromFloat(self.scroll_panel_009_scroll_view.width),
                    @intFromFloat(self.scroll_panel_009_scroll_view.height),
                );
                defer raylib.endScissorMode();

                // Draw the console text inside the scroll panel
                raylib.drawText(&c.zooid_system_out_buffer, @intFromFloat(startX), @intFromFloat(startY), 10, .black);
            }
        } else {
            _ = c.view.back();
            self.window_box_000_active = true; // Reopen the window box when returning to this view
        }
    }
};
