const std = @import("std");
const raylib = @import("raylib");
const raygui = @import("raygui");
const Vector2 = @import("raylib").Vector2;
const Rectangle = @import("raylib").Rectangle;

// Static text values never change, so they live as package-level consts
const TextBox017Text: [:0]const u8 = "SAMPLE TEXT";

pub const SettingsGui = struct {
    anchor01: Vector2,

    window_box_000_active: bool,
    text_box_017_edit_mode: bool,

    scroll_panel_004_scroll_view: Rectangle,
    scroll_panel_004_scroll_offset: Vector2,
    scroll_panel_004_bounds_offset: Vector2,

    layout_recs: [8]Rectangle,

    pub fn init(allocator: std.mem.Allocator) SettingsGui {
        _ = allocator;
        var self: SettingsGui = undefined;

        // Init anchors
        self.anchor01 = Vector2{ .x = 24, .y = 24 };

        // Init control variables
        self.window_box_000_active = true;
        self.text_box_017_edit_mode = false;

        // Init scroll panel state
        self.scroll_panel_004_scroll_view = Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };
        self.scroll_panel_004_scroll_offset = Vector2{ .x = 0, .y = 0 };
        self.scroll_panel_004_bounds_offset = Vector2{ .x = 0, .y = 0 };

        // Init layout rectangles (matching settings.h exactly, no scaling)
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

    pub fn draw(self: *SettingsGui) void {
        const WindowBox000Text: [:0]const u8 = "app settings "; // WINDOWBOX: WindowBox000
        const DummyRec018Text: [:0]const u8 = "sherch settings"; // DUMMYREC: DummyRec018
        const Button019Text: [:0]const u8 = "save"; // BUTTON: Button019
        const Button005Text: [:0]const u8 = "reset"; // BUTTON: Button005
        const Button006Text: [:0]const u8 = "export"; // BUTTON: Button006
        const Button007Text: [:0]const u8 = "load"; // BUTTON: Button007
        const ScrollPanel004Text: ?[*:0]const u8 = null;

        if (self.window_box_000_active) {
            self.window_box_000_active = !(raygui.windowBox(self.layout_recs[0], WindowBox000Text) > 0);
            if (raygui.textBox(self.layout_recs[1], @constCast(TextBox017Text), self.text_box_017_edit_mode)) self.text_box_017_edit_mode = !self.text_box_017_edit_mode;
            _ = raygui.dummyRec(self.layout_recs[2], DummyRec018Text);
            if (raygui.button(self.layout_recs[3], Button019Text)) {} // Button019 logic
            _ = raygui.scrollPanel(self.layout_recs[4], ScrollPanel004Text, self.layout_recs[4], &self.scroll_panel_004_scroll_offset, &self.scroll_panel_004_scroll_view);
            if (raygui.button(self.layout_recs[5], Button005Text)) {} // Button005 logic
            if (raygui.button(self.layout_recs[6], Button006Text)) {} // Button006 logic
            if (raygui.button(self.layout_recs[7], Button007Text)) {} // Button007 logic
        }
    }
};
