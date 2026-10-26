/*******************************************************************************************
*
*   LayoutName v1.0.0 - Tool Description
*
*   MODULE USAGE:
*       #define GUI_LAYOUT_NAME_IMPLEMENTATION
*       #include "gui_layout_name.h"
*
*       INIT: GuiLayoutNameState state = InitGuiLayoutName();
*       DRAW: GuiLayoutName(&state);
*
*   LICENSE: Propietary License
*
*   Copyright (c) 2022 raylib technologies. All Rights Reserved.
*
*   Unauthorized copying of this file, via any medium is strictly prohibited
*   This project is proprietary and confidential unless the owner allows
*   usage in any other form by expresely written permission.
*
**********************************************************************************************/

#include "raylib.h"

// WARNING: raygui implementation is expected to be defined before including this header
#undef RAYGUI_IMPLEMENTATION
#include "raygui.h"

#include <string.h>     // Required for: strcpy()

#ifndef GUI_LAYOUT_NAME_H
#define GUI_LAYOUT_NAME_H

typedef struct {
    // Define anchors
    Vector2 anchor01;            // ANCHOR ID:1
    Vector2 anchor02;            // ANCHOR ID:2
    
    // Define controls variables
    bool WindowBox000Active;            // WindowBox: WindowBox000
    bool TextBox002EditMode;
    char TextBox002Text[128];            // TextBox: TextBox002
    bool TextBox005EditMode;
    char TextBox005Text[128];            // TextBox: TextBox005
    Rectangle ScrollPanel009ScrollView;
    Vector2 ScrollPanel009ScrollOffset;
    Vector2 ScrollPanel009BoundsOffset;            // ScrollPanel: ScrollPanel009

    // Define rectangles
    Rectangle layoutRecs[10];

    // Custom state variables (depend on development software)
    // NOTE: This variables should be added manually if required

} GuiLayoutNameState;

#ifdef __cplusplus
extern "C" {            // Prevents name mangling of functions
#endif

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------
//...

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
// ...

//----------------------------------------------------------------------------------
// Module Functions Declaration
//----------------------------------------------------------------------------------
GuiLayoutNameState InitGuiLayoutName(void);
void GuiLayoutName(GuiLayoutNameState *state);
static void Button001();                // Button: Button001 logic
static void LabelButton003();                // LabelButton: LabelButton003 logic
static void LabelButton004();                // LabelButton: LabelButton004 logic
static void Button007();                // Button: Button007 logic

#ifdef __cplusplus
}
#endif

#endif // GUI_LAYOUT_NAME_H

/***********************************************************************************
*
*   GUI_LAYOUT_NAME IMPLEMENTATION
*
************************************************************************************/
#if defined(GUI_LAYOUT_NAME_IMPLEMENTATION)

#include "raygui.h"

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
//...

//----------------------------------------------------------------------------------
// Internal Module Functions Definition
//----------------------------------------------------------------------------------
//...

//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
GuiLayoutNameState InitGuiLayoutName(void)
{
    GuiLayoutNameState state = { 0 };

    // Init anchors
    state.anchor01 = (Vector2){ 360, 192 };            // ANCHOR ID:1
    state.anchor02 = (Vector2){ 368, 368 };            // ANCHOR ID:2
    
    // Initilize controls variables
    state.WindowBox000Active = true;            // WindowBox: WindowBox000
    state.TextBox002EditMode = false;
    strcpy(state.TextBox002Text, "SAMPLE TEXT");            // TextBox: TextBox002
    state.TextBox005EditMode = false;
    strcpy(state.TextBox005Text, "SAMPLE TEXT");            // TextBox: TextBox005
    state.ScrollPanel009ScrollView = (Rectangle){ 0, 0, 0, 0 };
    state.ScrollPanel009ScrollOffset = (Vector2){ 0, 0 };
    state.ScrollPanel009BoundsOffset = (Vector2){ 0, 0 };            // ScrollPanel: ScrollPanel009

    // Init controls rectangles
    state.layoutRecs[0] = (Rectangle){ state.anchor01.x + 0, state.anchor01.y + 0, 448, 360 };// WindowBox: WindowBox000
    state.layoutRecs[1] = (Rectangle){ state.anchor01.x + 368, state.anchor01.y + 128, 64, 48 };// Button: Button001
    state.layoutRecs[2] = (Rectangle){ state.anchor01.x + 104, state.anchor01.y + 40, 328, 32 };// TextBox: TextBox002
    state.layoutRecs[3] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 40, 96, 32 };// LabelButton: LabelButton003
    state.layoutRecs[4] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 88, 96, 32 };// LabelButton: LabelButton004
    state.layoutRecs[5] = (Rectangle){ state.anchor01.x + 104, state.anchor01.y + 88, 328, 32 };// TextBox: TextBox005
    state.layoutRecs[6] = (Rectangle){ state.anchor01.x + 296, state.anchor01.y + 128, 64, 48 };// Button: Button007
    state.layoutRecs[7] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 128, 120, 24 };// Label: Label009
    state.layoutRecs[8] = (Rectangle){ state.anchor02.x + 0, state.anchor02.y + 16, 432, 160 };// GroupBox: GroupBox008
    state.layoutRecs[9] = (Rectangle){ state.anchor02.x + 8, state.anchor02.y + 24, 416, 144 };// ScrollPanel: ScrollPanel009

    // Custom variables initialization

    return state;
}
// Button: Button001 logic
static void Button001()
{
    // TODO: Implement control logic
}
// LabelButton: LabelButton003 logic
static void LabelButton003()
{
    // TODO: Implement control logic
}
// LabelButton: LabelButton004 logic
static void LabelButton004()
{
    // TODO: Implement control logic
}
// Button: Button007 logic
static void Button007()
{
    // TODO: Implement control logic
}


void GuiLayoutName(GuiLayoutNameState *state)
{
    // Const text
    const char *WindowBox000Text = "login";    // WINDOWBOX: WindowBox000
    const char *Button001Text = "login";    // BUTTON: Button001
    const char *LabelButton003Text = "email";    // LABELBUTTON: LabelButton003
    const char *LabelButton004Text = "email password";    // LABELBUTTON: LabelButton004
    const char *Button007Text = "clear";    // BUTTON: Button007
    const char *Label009Text = "";    // LABEL: Label009
    const char *GroupBox008Text = "console";    // GROUPBOX: GroupBox008
    
    // Draw controls
    if (state->WindowBox000Active)
    {
        state->WindowBox000Active = !GuiWindowBox(state->layoutRecs[0], WindowBox000Text);
        if (GuiButton(state->layoutRecs[1], Button001Text)) Button001(); 
        if (GuiTextBox(state->layoutRecs[2], state->TextBox002Text, 128, state->TextBox002EditMode)) state->TextBox002EditMode = !state->TextBox002EditMode;
        if (GuiLabelButton(state->layoutRecs[3], LabelButton003Text)) LabelButton003();
        if (GuiLabelButton(state->layoutRecs[4], LabelButton004Text)) LabelButton004();
        if (GuiTextBox(state->layoutRecs[5], state->TextBox005Text, 128, state->TextBox005EditMode)) state->TextBox005EditMode = !state->TextBox005EditMode;
        if (GuiButton(state->layoutRecs[6], Button007Text)) Button007(); 
        GuiLabel(state->layoutRecs[7], Label009Text);
    }
    GuiGroupBox(state->layoutRecs[8], GroupBox008Text);
    GuiScrollPanel((Rectangle){state->layoutRecs[9].x, state->layoutRecs[9].y, state->layoutRecs[9].width - state->ScrollPanel009BoundsOffset.x, state->layoutRecs[9].height - state->ScrollPanel009BoundsOffset.y }, ScrollPanel009Text, state->layoutRecs[9], &state->ScrollPanel009ScrollOffset, &state->ScrollPanel009ScrollView);
}

#endif // GUI_LAYOUT_NAME_IMPLEMENTATION
