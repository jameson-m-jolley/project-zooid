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
    
    // Define controls variables
    bool WindowBox000Active;            // WindowBox: WindowBox000
    bool TextBox003EditMode;
    char TextBox003Text[128];            // TextBox: TextBox003
    bool Spinner004EditMode;
    int Spinner004Value;            // Spinner: Spinner004
    bool TextBox007EditMode;
    char TextBox007Text[128];            // TextBox: TextBox007
    bool DropdownBox010EditMode;
    int DropdownBox010Active;            // DropdownBox: DropdownBox010
    Rectangle ScrollPanel012ScrollView;
    Vector2 ScrollPanel012ScrollOffset;
    Vector2 ScrollPanel012BoundsOffset;            // ScrollPanel: ScrollPanel012

    // Define rectangles
    Rectangle layoutRecs[14];

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
static void Button002();                // Button: Button002 logic
static void Button005();                // Button: Button005 logic
static void Button006();                // Button: Button006 logic
static void LabelButton008();                // LabelButton: LabelButton008 logic

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
    state.anchor01 = (Vector2){ 24, 24 };            // ANCHOR ID:1
    
    // Initilize controls variables
    state.WindowBox000Active = true;            // WindowBox: WindowBox000
    state.TextBox003EditMode = false;
    strcpy(state.TextBox003Text, "SAMPLE TEXT");            // TextBox: TextBox003
    state.Spinner004EditMode = false;
    state.Spinner004Value = 0;            // Spinner: Spinner004
    state.TextBox007EditMode = false;
    strcpy(state.TextBox007Text, "");            // TextBox: TextBox007
    state.DropdownBox010EditMode = false;
    state.DropdownBox010Active = 0;            // DropdownBox: DropdownBox010
    state.ScrollPanel012ScrollView = (Rectangle){ 0, 0, 0, 0 };
    state.ScrollPanel012ScrollOffset = (Vector2){ 0, 0 };
    state.ScrollPanel012BoundsOffset = (Vector2){ 0, 0 };            // ScrollPanel: ScrollPanel012

    // Init controls rectangles
    state.layoutRecs[0] = (Rectangle){ state.anchor01.x + 0, state.anchor01.y + 0, 1256, 808 };// WindowBox: WindowBox000
    state.layoutRecs[1] = (Rectangle){ state.anchor01.x + 224, state.anchor01.y + 72, 1016, 672 };// Panel: Panel001
    state.layoutRecs[2] = (Rectangle){ state.anchor01.x + 1120, state.anchor01.y + 752, 120, 48 };// Button: Button002
    state.layoutRecs[3] = (Rectangle){ state.anchor01.x + 224, state.anchor01.y + 752, 888, 48 };// TextBox: TextBox003
    state.layoutRecs[4] = (Rectangle){ state.anchor01.x + 1120, state.anchor01.y + 40, 120, 24 };// Spinner: Spinner004
    state.layoutRecs[5] = (Rectangle){ state.anchor01.x + 912, state.anchor01.y + 40, 120, 24 };// Button: Button005
    state.layoutRecs[6] = (Rectangle){ state.anchor01.x + 784, state.anchor01.y + 40, 120, 24 };// Button: Button006
    state.layoutRecs[7] = (Rectangle){ state.anchor01.x + 312, state.anchor01.y + 40, 464, 24 };// TextBox: TextBox007
    state.layoutRecs[8] = (Rectangle){ state.anchor01.x + 224, state.anchor01.y + 40, 120, 24 };// LabelButton: LabelButton008
    state.layoutRecs[9] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 32, 208, 576 };// Panel: Panel009
    state.layoutRecs[10] = (Rectangle){ state.anchor01.x + 16, state.anchor01.y + 72, 192, 24 };// DropdownBox: DropdownBox010
    state.layoutRecs[11] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 616, 208, 24 };// DummyRec: DummyRec011
    state.layoutRecs[12] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 648, 208, 152 };// ScrollPanel: ScrollPanel012
    state.layoutRecs[13] = (Rectangle){ state.anchor01.x + 16, state.anchor01.y + 40, 192, 24 };// DummyRec: DummyRec013

    // Custom variables initialization

    return state;
}
// Button: Button002 logic
static void Button002()
{
    // TODO: Implement control logic
}
// Button: Button005 logic
static void Button005()
{
    // TODO: Implement control logic
}
// Button: Button006 logic
static void Button006()
{
    // TODO: Implement control logic
}
// LabelButton: LabelButton008 logic
static void LabelButton008()
{
    // TODO: Implement control logic
}


void GuiLayoutName(GuiLayoutNameState *state)
{
    // Const text
    const char *WindowBox000Text = "dashbord";    // WINDOWBOX: WindowBox000
    const char *Button002Text = "SAMPLE TEXT";    // BUTTON: Button002
    const char *Button005Text = "settings";    // BUTTON: Button005
    const char *Button006Text = "friends";    // BUTTON: Button006
    const char *LabelButton008Text = "sherch";    // LABELBUTTON: LabelButton008
    const char *DropdownBox010Text = "ONE;TWO;THREE";    // DROPDOWNBOX: DropdownBox010
    const char *DummyRec011Text = "zooid system";    // DUMMYREC: DummyRec011
    const char *DummyRec013Text = "colonies";    // DUMMYREC: DummyRec013
    
    // Draw controls
    if (state->DropdownBox010EditMode) GuiLock();

    if (state->WindowBox000Active)
    {
        state->WindowBox000Active = !GuiWindowBox(state->layoutRecs[0], WindowBox000Text);
        GuiPanel(state->layoutRecs[1], Panel001Text);
        if (GuiButton(state->layoutRecs[2], Button002Text)) Button002(); 
        if (GuiTextBox(state->layoutRecs[3], state->TextBox003Text, 128, state->TextBox003EditMode)) state->TextBox003EditMode = !state->TextBox003EditMode;
        if (GuiSpinner(state->layoutRecs[4], Spinner004Text, &state->Spinner004Value, 0, 100, state->Spinner004EditMode)) state->Spinner004EditMode = !state->Spinner004EditMode;
        if (GuiButton(state->layoutRecs[5], Button005Text)) Button005(); 
        if (GuiButton(state->layoutRecs[6], Button006Text)) Button006(); 
        if (GuiTextBox(state->layoutRecs[7], state->TextBox007Text, 128, state->TextBox007EditMode)) state->TextBox007EditMode = !state->TextBox007EditMode;
        if (GuiLabelButton(state->layoutRecs[8], LabelButton008Text)) LabelButton008();
        GuiPanel(state->layoutRecs[9], Panel009Text);
        GuiDummyRec(state->layoutRecs[11], DummyRec011Text);
        GuiScrollPanel((Rectangle){state->layoutRecs[12].x, state->layoutRecs[12].y, state->layoutRecs[12].width - state->ScrollPanel012BoundsOffset.x, state->layoutRecs[12].height - state->ScrollPanel012BoundsOffset.y }, ScrollPanel012Text, state->layoutRecs[12], &state->ScrollPanel012ScrollOffset, &state->ScrollPanel012ScrollView);
        GuiDummyRec(state->layoutRecs[13], DummyRec013Text);
        if (GuiDropdownBox(state->layoutRecs[10], DropdownBox010Text, &state->DropdownBox010Active, state->DropdownBox010EditMode)) state->DropdownBox010EditMode = !state->DropdownBox010EditMode;
    }
    
    GuiUnlock();
}

#endif // GUI_LAYOUT_NAME_IMPLEMENTATION
