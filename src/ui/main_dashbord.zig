const std = @import("std");
const raylib = @import("raylib");
const raygui = @import("raygui");
const Vector2 = @import("raylib").Vector2;
const Rectangle = @import("raylib").Rectangle;

// Static text values never change, so they live as package-level consts
const TextBox002Text: [:0]const u8 = "type msg";
const TextBox005Text: [:0]const u8 = "search";
const TextBox009Text: [:0]const u8 = "SAMPLE TEXT";

pub const MainDashbord = struct {
    anchor01: Vector2,
    anchor02: Vector2,

    var_text_box_002_edit_mode: bool,
    var_spinner_005_edit_mode: bool,
    var_spinner_005_value: i32,
    var_text_box_005_edit_mode: bool,
    var_list_view_008_scroll_index: i32,
    var_list_view_008_active: i32,
    var_text_box_009_edit_mode: bool,
    var_list_view_011_scroll_index: i32,
    var_list_view_011_active: i32,

    scroll_panel_scroll_view: Rectangle,
    scroll_panel_scroll_offset: Vector2,
    scroll_panel_bounds_offset: Vector2,

    layout_recs: [20]Rectangle,

    pub fn init(allocator: std.mem.Allocator, view_width: f32, view_height: f32) MainDashbord {
        _ = allocator;
        _ = view_width;
        _ = view_height;
        var self: MainDashbord = undefined;

        // Init anchors
        self.anchor01 = Vector2{ .x = 24, .y = 24 };
        self.anchor02 = Vector2{ .x = 280, .y = 32 };

        // Init control variables
        self.var_text_box_002_edit_mode = false;
        self.var_spinner_005_edit_mode = false;
        self.var_spinner_005_value = 0;
        self.var_text_box_005_edit_mode = false;
        self.var_list_view_008_scroll_index = 0;
        self.var_list_view_008_active = 0;
        self.var_text_box_009_edit_mode = false;
        self.var_list_view_011_scroll_index = 0;
        self.var_list_view_011_active = 0;

        // Init scroll panel state
        self.scroll_panel_scroll_view = Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };
        self.scroll_panel_scroll_offset = Vector2{ .x = 0, .y = 0 };
        self.scroll_panel_bounds_offset = Vector2{ .x = 0, .y = 0 };

        // Init layout rectangles (matching gui_main.h exactly, no scaling)
        self.layout_recs = undefined;

        self.layout_recs[0] = Rectangle{ .x = self.anchor01.x + 0, .y = self.anchor01.y + 8, .width = 240.0, .height = 688.0 }; // GroupBox: GroupBox000
        self.layout_recs[1] = Rectangle{ .x = self.anchor02.x + 0, .y = self.anchor02.y + 0, .width = 800.0, .height = 688.0 }; // GroupBox: GroupBox001
        self.layout_recs[2] = Rectangle{ .x = self.anchor02.x + 8, .y = self.anchor02.y + 648, .width = 664.0, .height = 32.0 }; // TextBox: TextBox002
        self.layout_recs[3] = Rectangle{ .x = self.anchor02.x + 688, .y = self.anchor02.y + 648, .width = 96.0, .height = 32.0 }; // Button: Button003
        self.layout_recs[4] = Rectangle{ .x = self.anchor02.x + 624, .y = self.anchor02.y + 16, .width = 160.0, .height = 32.0 }; // Spinner: Spinner005
        self.layout_recs[5] = Rectangle{ .x = self.anchor02.x + 16, .y = self.anchor02.y + 16, .width = 216.0, .height = 32.0 }; // TextBox: TextBox005
        self.layout_recs[6] = Rectangle{ .x = self.anchor02.x + 16, .y = self.anchor02.y + 56, .width = 768.0, .height = 16.0 }; // Line: Line006
        self.layout_recs[7] = Rectangle{ .x = self.anchor02.x + 8, .y = self.anchor02.y + 624, .width = 776.0, .height = 12.0 }; // Line: Line007
        self.layout_recs[8] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 96, .width = 224.0, .height = 96.0 }; // ListView: ListView008
        self.layout_recs[9] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 56, .width = 224.0, .height = 32.0 }; // TextBox: TextBox009
        self.layout_recs[10] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 248, .width = 224.0, .height = 16.0 }; // Line: Line010
        self.layout_recs[11] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 312, .width = 224.0, .height = 176.0 }; // ListView: ListView011
        self.layout_recs[12] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 272, .width = 224.0, .height = 32.0 }; // DummyRec: DummyRec012
        self.layout_recs[13] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 16, .width = 224.0, .height = 32.0 }; // DummyRec: DummyRec013
        self.layout_recs[14] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 496, .width = 224.0, .height = 32.0 }; // Button: Button019
        self.layout_recs[15] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 200, .width = 224.0, .height = 40.0 }; // Button: Button015
        self.layout_recs[16] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 536, .width = 224.0, .height = 16.0 }; // Line: Line016
        self.layout_recs[17] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 592, .width = 224.0, .height = 96.0 }; // ScrollPanel: ScrollPanel017
        self.layout_recs[18] = Rectangle{ .x = self.anchor01.x + 8, .y = self.anchor01.y + 552, .width = 96.0, .height = 32.0 }; // DummyRec: DummyRec018
        self.layout_recs[19] = Rectangle{ .x = self.anchor01.x + 112, .y = self.anchor01.y + 552, .width = 120.0, .height = 32.0 }; // Button: Button019

        return self;
    }

    pub fn deinit(self: MainDashbord) void {
        _ = self;
    }

    pub fn draw(self: *MainDashbord) void {
        const GroupBox000Text: [:0]const u8 = "SAMPLE TEXT"; // GROUPBOX: GroupBox000
        const GroupBox001Text: [:0]const u8 = "messages"; // GROUPBOX: GroupBox001
        const Button003Text: [:0]const u8 = " >>>"; // BUTTON: Button003
        const ListView008Text: [:0]const u8 = "ONE;TWO;THREE"; // LISTVIEW: ListView008
        const ListView011Text: [:0]const u8 = "ONE;TWO;THREE"; // LISTVIEW: ListView011
        const DummyRec012Text: [:0]const u8 = "friends"; // DUMMYREC: DummyRec012
        const DummyRec013Text: [:0]const u8 = "zooid colonys"; // DUMMYREC: DummyRec013
        const Button019Text: [:0]const u8 = "settings"; // BUTTON: Button019
        const Button015Text: [:0]const u8 = "settings"; // BUTTON: Button015
        const DummyRec018Text: [:0]const u8 = "zooid_logs"; // DUMMYREC: DummyRec018

        _ = raygui.groupBox(self.layout_recs[0], GroupBox000Text);
        _ = raygui.groupBox(self.layout_recs[1], GroupBox001Text);
        if (raygui.textBox(self.layout_recs[2], @constCast(TextBox002Text), self.var_text_box_002_edit_mode)) self.var_text_box_002_edit_mode = !self.var_text_box_002_edit_mode;
        if (raygui.button(self.layout_recs[3], Button003Text)) {} // Button003 logic
        if (raygui.spinner(self.layout_recs[4], "", &self.var_spinner_005_value, 0, 100, self.var_spinner_005_edit_mode) > 0) self.var_spinner_005_edit_mode = !self.var_spinner_005_edit_mode;
        if (raygui.textBox(self.layout_recs[5], @constCast(TextBox005Text), self.var_text_box_005_edit_mode)) self.var_text_box_005_edit_mode = !self.var_text_box_005_edit_mode;
        _ = raygui.line(self.layout_recs[6], "");
        _ = raygui.line(self.layout_recs[7], "");
        _ = raygui.listView(self.layout_recs[8], ListView008Text, &self.var_list_view_008_scroll_index, &self.var_list_view_008_active);
        if (raygui.textBox(self.layout_recs[9], @constCast(TextBox009Text), self.var_text_box_009_edit_mode)) self.var_text_box_009_edit_mode = !self.var_text_box_009_edit_mode;
        _ = raygui.line(self.layout_recs[10], "");
        _ = raygui.listView(self.layout_recs[11], ListView011Text, &self.var_list_view_011_scroll_index, &self.var_list_view_011_active);
        _ = raygui.dummyRec(self.layout_recs[12], DummyRec012Text);
        _ = raygui.dummyRec(self.layout_recs[13], DummyRec013Text);
        if (raygui.button(self.layout_recs[14], Button019Text)) {} // Button019 logic
        if (raygui.button(self.layout_recs[15], Button015Text)) {} // Button015 logic
        _ = raygui.line(self.layout_recs[16], "");
        _ = raygui.scrollPanel(self.layout_recs[17], "", self.layout_recs[17], &self.scroll_panel_scroll_offset, &self.scroll_panel_scroll_view);
        _ = raygui.dummyRec(self.layout_recs[18], DummyRec018Text);
        if (raygui.button(self.layout_recs[19], Button019Text)) {} // Button019 logic
    }
};
