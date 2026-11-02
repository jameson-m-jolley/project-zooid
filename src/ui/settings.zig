const std = @import("std");
const raylib = @import("raylib");
const raygui = @import("raygui");
const view = @import("view.zig");
const Vector2 = @import("raylib").Vector2;

const Rectangle = @import("raylib").Rectangle;

// this is the settings for the app
// this holds all the user facing settings that the user can change,
// and the app will use these settings to change its behavior
pub const settings = struct {
    cpu_throttle: u32 = 0,
    ui_update_interval: f32 = 10.0, //default to 10 seconds, can be changed by user in settings
};

pub const SettingsGui = struct {
    anchor01: Vector2,

    window_box_000_active: bool,
    text_box_017_edit_mode: bool,
    text_box_017_text: [128:0]u8,

    scroll_panel_004_scroll_view: Rectangle,
    scroll_panel_004_scroll_offset: Vector2,
    scroll_panel_004_bounds_offset: Vector2,

    layout_recs: [8]Rectangle,

    pub fn init(allocator: std.mem.Allocator) SettingsGui {
        _ = allocator;
        var self: SettingsGui = undefined;
        self.anchor01 = Vector2{ .x = 24, .y = 24 };
        self.window_box_000_active = true;
        self.text_box_017_edit_mode = false;

        // Zero-fill text buffer once at creation so raygui.textBox does not render garbage '?'
        self.text_box_017_text = @splat('\x00');

        // Set initial text value
        _ = std.mem.copySentinel(u8, 0, self.text_box_017_text[0..], "SAMPLE TEXT");

        self.scroll_panel_004_scroll_view = Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };
        self.scroll_panel_004_scroll_offset = Vector2{ .x = 0, .y = 0 };
        self.scroll_panel_004_bounds_offset = Vector2{ .x = 0, .y = 0 };
        self.layout_recs = undefined;
        self.layout_recs[0] = Rectangle{ .x = self.anchor01.x + 0, .y = self.anchor01.y + 0, .width = 784, .height = 544 }; // WindowBox: WindowBox000
        self.layout_recs[1] = Rectangle{ .x = self.anchor01.x + 152, .y = self.anchor01.y + 32, .width = 392, .height = 24 }; // TextBox: TextBox017
        self.layout_recs[2] = Rectangle{ .x = self.anchor01.x + 24, .y = self.anchor01.y + 32, .width = 120, .height = 24 }; // DummyRec: DummyRec018
        self.layout_recs[3] = Rectangle{ .x = self.anchor01.x + 552, .y = self.anchor01.y + 32, .width = 48, .height = 24 }; // Button: Button019
        self.layout_recs[4] = Rectangle{ .x = self.anchor01.x + 24, .y = self.anchor01.y + 72, .width = 744, .height = 456 }; // ScrollPanel: ScrollPanel004
        self.layout_recs[5] = Rectangle{ .x = self.anchor01.x + 608, .y = self.anchor01.y + 32, .width = 48, .height = 24 }; // Button: Button005
        self.layout_recs[6] = Rectangle{ .x = self.anchor01.x + 664, .y = self.anchor01.y + 32, .width = 48, .height = 24 }; // Button: Button006
        self.layout_recs[7] = Rectangle{ .x = self.anchor01.x + 720, .y = self.anchor01.y + 32, .width = 48, .height = 24 }; // Button: Button007
        return self;
    }
    pub fn deinit(self: SettingsGui) void {
        _ = self;
    }

    pub fn draw(self: *SettingsGui, v: *view.gen_view()) void {
        const WindowBox000Text: [:0]const u8 = "app settings "; // WINDOWBOX: WindowBox000
        const DummyRec018Text: [:0]const u8 = "sherch settings"; // DUMMYREC: DummyRec018
        const Button019Text: [:0]const u8 = "save"; // BUTTON: Button019
        const Button005Text: [:0]const u8 = "reset"; // BUTTON: Button005
        const Button006Text: [:0]const u8 = "export"; // BUTTON: Button006
        const Button007Text: [:0]const u8 = "load"; // BUTTON: Button007
        const ScrollPanel004Text: ?[*:0]const u8 = null;
        if (self.window_box_000_active) {
            self.window_box_000_active = !(raygui.windowBox(self.layout_recs[0], WindowBox000Text) > 0);
            if (raygui.textBox(self.layout_recs[1], &self.text_box_017_text, self.text_box_017_edit_mode)) self.text_box_017_edit_mode = !self.text_box_017_edit_mode;
            _ = raygui.dummyRec(self.layout_recs[2], DummyRec018Text);
            if (raygui.button(self.layout_recs[3], Button019Text)) {} // Button019 logic
            _ = raygui.scrollPanel(self.layout_recs[4], ScrollPanel004Text, self.layout_recs[4], &self.scroll_panel_004_scroll_offset, &self.scroll_panel_004_scroll_view);
            if (raygui.button(self.layout_recs[5], Button005Text)) {} // Button005 logic
            if (raygui.button(self.layout_recs[6], Button006Text)) {} // Button006 logic
            if (raygui.button(self.layout_recs[7], Button007Text)) {} // Button007 logic
        } else {
            if (!v.back()) {
                v.goto(.main) catch {}; // Navigate to main view if stack is empty
            }
            self.window_box_000_active = true; // Reset for next time
        }
        // Return false to indicate no interaction is happening
    }
};
