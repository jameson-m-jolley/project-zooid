const std = @import("std");
const raylib = @import("raylib");
const Vector2 = @import("raylib").Vector2;
const Rectangle = @import("raylib").Rectangle;

pub const GuiMainState = struct {
    // Anchors define reference points for layout
    anchor01: Vector2,
    anchor02: Vector2,

    // Control state variables
    var_text_box_002_edit_mode: bool,
    var_text_box_002_text: [128]u8,
    var_spinner_005_edit_mode: bool,
    var_spinner_005_value: i32,
    var_text_box_005_edit_mode: bool,
    var_text_box_005_text: [128]u8,
    var_list_view_008_scroll_index: i32,
    var_list_view_008_active: i32,
    var_text_box_009_edit_mode: bool,
    var_text_box_009_text: [128]u8,
    var_list_view_011_scroll_index: i32,
    var_list_view_011_active: i32,

    // Scroll panel state
    scroll_panel_scroll_view: Rectangle,
    scroll_panel_scroll_offset: Vector2,
    scroll_panel_bounds_offset: Vector2,

    // Layout rectangles
    layout_recs: [20]Rectangle,

    // Custom state variables
};

pub fn init_gui_main(allocator: std.mem.Allocator, view_width: f32, view_height: f32) !GuiMainState {
    _ = allocator;
    var state = GuiMainState{};

    // Init anchors (centered reference points)
    state.anchor01 = Vector2{ .x = 24, .y = 24 };
    state.anchor02 = Vector2{ .x = 280, .y = 32 };

    // Initialize control variables
    state.var_text_box_002_edit_mode = false;
    state.var_text_box_002_text = "type msg";

    state.var_spinner_005_edit_mode = false;
    state.var_spinner_005_value = 0;

    state.var_text_box_005_edit_mode = false;
    state.var_text_box_005_text = "search";

    state.var_list_view_008_scroll_index = 0;
    state.var_list_view_008_active = 0;

    state.var_text_box_009_edit_mode = false;
    state.var_text_box_009_text = "SAMPLE TEXT";

    state.var_list_view_011_scroll_index = 0;
    state.var_list_view_011_active = 0;

    // Init scroll panel state
    state.scroll_panel_scroll_view = Rectangle{};
    state.scroll_panel_scroll_offset = Vector2{ .x = 0, .y = 0 };
    state.scroll_panel_bounds_offset = Vector2{ .x = 0, .y = 0 };

    // Init layout rectangles scaled to view size
    // Base anchor dimensions: anchor01 is ~24x24, anchor02 is ~280x32
    // We scale proportionally based on view dimensions
    const base_width: f32 = 304.0; // anchor01.x + anchor02.x approximately
    const base_height: f32 = 704.0; // anchor01.y + some offset

    state.layout_recs[0] = Rectangle{
        .x = state.anchor01.x + 0,
        .y = state.anchor01.y + 8,
        .width = 240.0 * (view_width / base_width),
        .height = 688.0 * (view_height / base_height),
    }; // GroupBox: GroupBox000

    state.layout_recs[1] = Rectangle{
        .x = state.anchor02.x + 0,
        .y = state.anchor02.y + 0,
        .width = 800.0 * (view_width / base_width),
        .height = 688.0 * (view_height / base_height),
    }; // GroupBox: GroupBox001

    state.layout_recs[2] = Rectangle{
        .x = state.anchor02.x + 8,
        .y = state.anchor02.y + 648,
        .width = 664.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // TextBox: TextBox002

    state.layout_recs[3] = Rectangle{
        .x = state.anchor02.x + 688,
        .y = state.anchor02.y + 648,
        .width = 96.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // Button: Button003

    state.layout_recs[4] = Rectangle{
        .x = state.anchor02.x + 624,
        .y = state.anchor02.y + 16,
        .width = 160.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // Spinner: Spinner005

    state.layout_recs[5] = Rectangle{
        .x = state.anchor02.x + 16,
        .y = state.anchor02.y + 16,
        .width = 216.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // TextBox: TextBox005

    state.layout_recs[6] = Rectangle{
        .x = state.anchor02.x + 16,
        .y = state.anchor02.y + 56,
        .width = 768.0 * (view_width / base_width),
        .height = 16.0 * (view_height / base_height),
    }; // Line: Line006

    state.layout_recs[7] = Rectangle{
        .x = state.anchor02.x + 8,
        .y = state.anchor02.y + 624,
        .width = 776.0 * (view_width / base_width),
        .height = 12.0 * (view_height / base_height),
    }; // Line: Line007

    state.layout_recs[8] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 96,
        .width = 224.0 * (view_width / base_width),
        .height = 96.0 * (view_height / base_height),
    }; // ListView: ListView008

    state.layout_recs[9] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 56,
        .width = 224.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // TextBox: TextBox009

    state.layout_recs[10] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 248,
        .width = 224.0 * (view_width / base_width),
        .height = 16.0 * (view_height / base_height),
    }; // Line: Line010

    state.layout_recs[11] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 312,
        .width = 224.0 * (view_width / base_width),
        .height = 176.0 * (view_height / base_height),
    }; // ListView: ListView011

    state.layout_recs[12] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 272,
        .width = 224.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // DummyRec: DummyRec012

    state.layout_recs[13] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 16,
        .width = 224.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // DummyRec: DummyRec013

    state.layout_recs[14] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 496,
        .width = 224.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // Button: Button019

    state.layout_recs[15] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 200,
        .width = 224.0 * (view_width / base_width),
        .height = 40.0 * (view_height / base_height),
    }; // Button: Button015

    state.layout_recs[16] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 536,
        .width = 224.0 * (view_width / base_width),
        .height = 16.0 * (view_height / base_height),
    }; // Line: Line016

    state.layout_recs[17] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 592,
        .width = 224.0 * (view_width / base_width),
        .height = 96.0 * (view_height / base_height),
    }; // ScrollPanel: ScrollPanel017

    state.layout_recs[18] = Rectangle{
        .x = state.anchor01.x + 8,
        .y = state.anchor01.y + 552,
        .width = 96.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // DummyRec: DummyRec018

    state.layout_recs[19] = Rectangle{
        .x = state.anchor01.x + 112,
        .y = state.anchor01.y + 552,
        .width = 120.0 * (view_width / base_width),
        .height = 32.0 * (view_height / base_height),
    }; // Button: Button019

    return state;
}

pub fn gui_main(state: *GuiMainState) void {
    // Draw controls
    const GroupBox000Text = "SAMPLE TEXT"; // GROUPBOX: GroupBox000
    const GroupBox001Text = "messages"; // GROUPBOX: GroupBox001
    const Button003Text = " >>>"; // BUTTON: Button003
    const ListView008Text = "ONE;TWO;THREE"; // LISTVIEW: ListView008
    const ListView011Text = "ONE;TWO;THREE"; // LISTVIEW: ListView011
    const DummyRec012Text = "friends"; // DUMMYREC: DummyRec012
    const DummyRec013Text = "zooid colonys"; // DUMMYREC: DummyRec013
    const Button019Text = "settings"; // BUTTON: Button019
    const Button015Text = "settings"; // BUTTON: Button015
    const DummyRec018Text = "zooid_logs"; // DUMMYREC: DummyRec018

    // Draw controls
    raylib.GuiGroupBox(state.layout_recs[0], GroupBox000Text);
    raylib.GuiGroupBox(state.layout_recs[1], GroupBox001Text);
    if (raylib.GuiTextBox(state.layout_recs[2], state.var_text_box_002_text[0..128], 128, state.var_text_box_002_edit_mode)) state.var_text_box_002_edit_mode = !state.var_text_box_002_edit_mode;
    if (raylib.GuiButton(state.layout_recs[3], Button003Text)) {} // Button003 logic
    if (raylib.GuiSpinner(state.layout_recs[4], &state.var_spinner_005_value, 0, 100, state.var_spinner_005_edit_mode)) state.var_spinner_005_edit_mode = !state.var_spinner_005_edit_mode;
    if (raylib.GuiTextBox(state.layout_recs[5], state.var_text_box_005_text[0..128], 128, state.var_text_box_005_edit_mode)) state.var_text_box_005_edit_mode = !state.var_text_box_005_edit_mode;
    raylib.GuiLine(state.layout_recs[6], "");
    raylib.GuiLine(state.layout_recs[7], "");
    raylib.GuiListView(state.layout_recs[8], ListView008Text, &state.var_list_view_008_scroll_index, &state.var_list_view_008_active);
    if (raylib.GuiTextBox(state.layout_recs[9], state.var_text_box_009_text[0..128], 128, state.var_text_box_009_edit_mode)) state.var_text_box_009_edit_mode = !state.var_text_box_009_edit_mode;
    raylib.GuiLine(state.layout_recs[10], "");
    raylib.GuiListView(state.layout_recs[11], ListView011Text, &state.var_list_view_011_scroll_index, &state.var_list_view_011_active);
    raylib.GuiDummyRec(state.layout_recs[12], DummyRec012Text);
    raylib.GuiDummyRec(state.layout_recs[13], DummyRec013Text);
    if (raylib.GuiButton(state.layout_recs[14], Button019Text)) {} // Button019 logic
    if (raylib.GuiButton(state.layout_recs[15], Button015Text)) {} // Button015 logic
    raylib.GuiLine(state.layout_recs[16], "");
    raylib.GuiScrollPanel(state.layout_recs[17], "", state.layout_recs[17], &state.scroll_panel_scroll_offset, &state.scroll_panel_scroll_view);
    raylib.GuiDummyRec(state.layout_recs[18], DummyRec018Text);
    if (raylib.GuiButton(state.layout_recs[19], Button019Text)) {} // Button019 logic
}
