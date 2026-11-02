const std = @import("std");
const raylib = @import("raylib");
const raygui = @import("raygui");
const Vector2 = @import("raylib").Vector2;
const Rectangle = @import("raylib").Rectangle;
const view = @import("view.zig");

// Static text values never change, so they live as package-level consts

pub const MainDashbord = struct {
    anchor01: Vector2,

    window_box_000_active: bool,
    text_box_003_edit_mode: bool,
    text_box_007_edit_mode: bool,
    text_box_003_text: [128:0]u8,
    text_box_007_text: [128:0]u8,

    spinner_004_edit_mode: bool,
    spinner_004_value: i32,

    dropdown_box_010_edit_mode: bool,
    dropdown_box_010_active: i32,

    scroll_panel_012_scroll_view: Rectangle,
    scroll_panel_012_scroll_offset: Vector2,
    scroll_panel_012_bounds_offset: Vector2,

    layout_recs: [14]Rectangle,

    pub fn init(allocator: std.mem.Allocator) MainDashbord {
        _ = allocator;
        var self: MainDashbord = undefined;

        // Init anchors
        self.anchor01 = Vector2{ .x = 24, .y = 24 }; // ANCHOR ID:1

        // Init control variables
        self.window_box_000_active = true;
        self.text_box_003_edit_mode = false;
        self.text_box_007_edit_mode = false;
        self.spinner_004_edit_mode = false;
        self.spinner_004_value = 0;
        self.dropdown_box_010_edit_mode = false;
        self.dropdown_box_010_active = 0;

        // Use @splat to initialize the text buffers to all zeros, which is required for raygui.textBox to work correctly
        self.text_box_003_text = @splat('\x00'); // Initialize to all zeros
        self.text_box_007_text = @splat('\x00'); // Initialize to all zeros

        // Set initial text values
        _ = std.mem.copySentinel(u8, 0, self.text_box_003_text[0..], "SAMPLE TEXT");
        _ = std.mem.copySentinel(u8, 0, self.text_box_007_text[0..], "");
        // Mutable buffers so raygui.textBox can write keystrokes into them

        // Init scroll panel state
        self.scroll_panel_012_scroll_view = Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };
        self.scroll_panel_012_scroll_offset = Vector2{ .x = 0, .y = 0 };
        self.scroll_panel_012_bounds_offset = Vector2{ .x = 0, .y = 0 };

        // Init layout rectangles (matching gui_layout_name.h / gui_main.h exactly, no scaling)
        self.layout_recs = undefined;

        self.layout_recs[0] = Rectangle{ .x = self.anchor01.x + 0, .y = self.anchor01.y + 0, .width = 1256, .height = 808 }; // WindowBox: WindowBox000
        self.layout_recs[1] = Rectangle{ .x = self.anchor01.x + 224, .y = self.anchor01.y + 72, .width = 1016, .height = 672 }; // GroupBox: GroupBox001
        self.layout_recs[2] = Rectangle{ .x = self.anchor01.x + 1120, .y = self.anchor01.y + 752, .width = 120, .height = 48 }; // Button: Button002
        self.layout_recs[3] = Rectangle{ .x = self.anchor01.x + 224, .y = self.anchor01.y + 752, .width = 888, .height = 48 }; // TextBox: TextBox003
        self.layout_recs[4] = Rectangle{ .x = self.anchor01.x + 1120, .y = self.anchor01.y + 40, .width = 120, .height = 24 }; // Spinner: Spinner004
        self.layout_recs[5] = Rectangle{ .x = self.anchor01.x + 912, .y = self.anchor01.y + 40, .width = 120, .height = 24 }; // Button: Button005
        self.layout_recs[6] = Rectangle{ .x = self.anchor01.x + 784, .y = self.anchor01.y + 40, .width = 120, .height = 24 }; // Button: Button006
        self.layout_recs[7] = Rectangle{ .x = self.anchor01.x + 312, .y = self.anchor01.y + 40, .width = 464, .height = 24 }; // TextBox: TextBox007
        self.layout_recs[8] = Rectangle{ .x = self.anchor01.x + 224, .y = self.anchor01.y + 40, .width = 120, .height = 24 }; // LabelButton: LabelButton008
        self.layout_recs[9] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 32, .width = 208, .height = 576 }; // GroupBox: GroupBox009
        self.layout_recs[10] = Rectangle{ .x = self.anchor01.x + 16, .y = self.anchor01.y + 72, .width = 192, .height = 24 }; // DropdownBox: DropdownBox010
        self.layout_recs[11] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 616, .width = 208, .height = 24 }; // DummyRec: DummyRec011
        self.layout_recs[12] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 648, .width = 208, .height = 152 }; // ScrollPanel: ScrollPanel012
        self.layout_recs[13] = Rectangle{ .x = self.anchor01.x + 16, .y = self.anchor01.y + 40, .width = 192, .height = 24 }; // DummyRec: DummyRec013

        return self;
    }

    pub fn deinit(self: MainDashbord) void {
        _ = self;
    }

    pub fn draw(self: *MainDashbord, v: *view.gen_view()) void {
        const WindowBox000Text: [:0]const u8 = "dashbord"; // WINDOWBOX: WindowBox000
        const GroupBox001Text: [:0]const u8 = ""; // GROUPBOX: GroupBox001
        const Button002Text: [:0]const u8 = "SAMPLE TEXT"; // BUTTON: Button002
        const Spinner004Text: [:0]const u8 = ""; // SPINNER: Spinner004
        const Button005Text: [:0]const u8 = "settings"; // BUTTON: Button005
        const Button006Text: [:0]const u8 = "friends"; // BUTTON: Button006
        const LabelButton008Text: [:0]const u8 = "sherch"; // LABELBUTTON: LabelButton008
        const GroupBox009Text: [:0]const u8 = ""; // GROUPBOX: GroupBox009
        const DropdownBox010Text: [:0]const u8 = "ONE;TWO;THREE"; // DROPDOWNBOX: DropdownBox010
        const DummyRec011Text: [:0]const u8 = "zooid system"; // DUMMYREC: DummyRec011
        const DummyRec013Text: [:0]const u8 = "colonies"; // DUMMYREC: DummyRec013
        var ScrollPanel012Text: ?[*:0]const u8 = null; // SCROLLPANEL: ScrollPanel012

        if (self.dropdown_box_010_edit_mode) raygui.lock();

        if (self.window_box_000_active) {
            self.window_box_000_active = !(raygui.windowBox(self.layout_recs[0], WindowBox000Text) > 0);
            _ = raygui.groupBox(self.layout_recs[1], GroupBox001Text);
            if (raygui.button(self.layout_recs[2], Button002Text)) {} // Button002 logic
            if (raygui.textBox(self.layout_recs[3], &self.text_box_003_text, self.text_box_003_edit_mode)) self.text_box_003_edit_mode = !self.text_box_003_edit_mode;
            if (raygui.spinner(self.layout_recs[4], Spinner004Text, &self.spinner_004_value, 0, 100, self.spinner_004_edit_mode) > 0) self.spinner_004_edit_mode = !self.spinner_004_edit_mode;
            if (raygui.button(self.layout_recs[5], Button005Text)) {
                v.goto(.settings) catch {
                    ScrollPanel012Text = "err going to settings.";
                };
            } // Button005 logic
            if (raygui.button(self.layout_recs[6], Button006Text)) {} // Button006 logic
            if (raygui.textBox(self.layout_recs[7], &self.text_box_007_text, self.text_box_007_edit_mode)) self.text_box_007_edit_mode = !self.text_box_007_edit_mode;
            if (raygui.labelButton(self.layout_recs[8], LabelButton008Text)) {} // LabelButton008 logic
            _ = raygui.groupBox(self.layout_recs[9], GroupBox009Text);
            _ = raygui.dummyRec(self.layout_recs[11], DummyRec011Text);
            _ = raygui.scrollPanel(
                Rectangle{
                    .x = self.layout_recs[12].x,
                    .y = self.layout_recs[12].y,
                    .width = self.layout_recs[12].width - self.scroll_panel_012_bounds_offset.x,
                    .height = self.layout_recs[12].height - self.scroll_panel_012_bounds_offset.y,
                },
                ScrollPanel012Text,
                self.layout_recs[12],
                &self.scroll_panel_012_scroll_offset,
                &self.scroll_panel_012_scroll_view,
            );
            _ = raygui.dummyRec(self.layout_recs[13], DummyRec013Text);
            if (raygui.dropdownBox(self.layout_recs[10], DropdownBox010Text, &self.dropdown_box_010_active, self.dropdown_box_010_edit_mode) > 0) self.dropdown_box_010_edit_mode = !self.dropdown_box_010_edit_mode;
        } else {
            _ = v.back();
        }

        raygui.unlock();
    }
};
