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
    bool TextBox017EditMode;
    char TextBox017Text[128];            // TextBox: TextBox017
    Rectangle ScrollPanel004ScrollView;
    Vector2 ScrollPanel004ScrollOffset;
    Vector2 ScrollPanel004BoundsOffset;            // ScrollPanel: ScrollPanel004

    // Define rectangles
    Rectangle layoutRecs[8];

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
static void Button019();                // Button: Button019 logic
static void Button005();                // Button: Button005 logic
static void Button006();                // Button: Button006 logic
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
    state.anchor01 = (Vector2){ 24, 24 };            // ANCHOR ID:1
    
    // Initilize controls variables
    state.WindowBox000Active = true;            // WindowBox: WindowBox000
    state.TextBox017EditMode = false;
    strcpy(state.TextBox017Text, "SAMPLE TEXT");            // TextBox: TextBox017
    state.ScrollPanel004ScrollView = (Rectangle){ 0, 0, 0, 0 };
    state.ScrollPanel004ScrollOffset = (Vector2){ 0, 0 };
    state.ScrollPanel004BoundsOffset = (Vector2){ 0, 0 };            // ScrollPanel: ScrollPanel004

    // Init controls rectangles
    state.layoutRecs[0] = (Rectangle){ state.anchor01.x + 0, state.anchor01.y + 0, 784, 544 };// WindowBox: WindowBox000
    state.layoutRecs[1] = (Rectangle){ state.anchor01.x + 152, state.anchor01.y + 32, 392, 24 };// TextBox: TextBox017
    state.layoutRecs[2] = (Rectangle){ state.anchor01.x + 24, state.anchor01.y + 32, 120, 24 };// DummyRec: DummyRec018
    state.layoutRecs[3] = (Rectangle){ state.anchor01.x + 552, state.anchor01.y + 32, 48, 24 };// Button: Button019
    state.layoutRecs[4] = (Rectangle){ state.anchor01.x + 24, state.anchor01.y + 72, 744, 456 };// ScrollPanel: ScrollPanel004
    state.layoutRecs[5] = (Rectangle){ state.anchor01.x + 608, state.anchor01.y + 32, 48, 24 };// Button: Button005
    state.layoutRecs[6] = (Rectangle){ state.anchor01.x + 664, state.anchor01.y + 32, 48, 24 };// Button: Button006
    state.layoutRecs[7] = (Rectangle){ state.anchor01.x + 720, state.anchor01.y + 32, 48, 24 };// Button: Button007

    // Custom variables initialization

    return state;
}
// Button: Button019 logic
static void Button019()
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
// Button: Button007 logic
static void Button007()
{
    // TODO: Implement control logic
}


void GuiLayoutName(GuiLayoutNameState *state)
{
    // Const text
    const char *WindowBox000Text = "app settings ";    // WINDOWBOX: WindowBox000
    const char *DummyRec018Text = "sherch settings";    // DUMMYREC: DummyRec018
    const char *Button019Text = "save";    // BUTTON: Button019
    const char *Button005Text = "reset";    // BUTTON: Button005
    const char *Button006Text = "export";    // BUTTON: Button006
    const char *Button007Text = "load";    // BUTTON: Button007
    
    // Draw controls
    if (state->WindowBox000Active)
    {
        state->WindowBox000Active = !GuiWindowBox(state->layoutRecs[0], WindowBox000Text);
        if (GuiTextBox(state->layoutRecs[1], state->TextBox017Text, 128, state->TextBox017EditMode)) state->TextBox017EditMode = !state->TextBox017EditMode;
        GuiDummyRec(state->layoutRecs[2], DummyRec018Text);
        if (GuiButton(state->layoutRecs[3], Button019Text)) Button019(); 
        GuiScrollPanel((Rectangle){state->layoutRecs[4].x, state->layoutRecs[4].y, state->layoutRecs[4].width - state->ScrollPanel004BoundsOffset.x, state->layoutRecs[4].height - state->ScrollPanel004BoundsOffset.y }, ScrollPanel004Text, state->layoutRecs[4], &state->ScrollPanel004ScrollOffset, &state->ScrollPanel004ScrollView);
        if (GuiButton(state->layoutRecs[5], Button005Text)) Button005(); 
        if (GuiButton(state->layoutRecs[6], Button006Text)) Button006(); 
        if (GuiButton(state->layoutRecs[7], Button007Text)) Button007(); 
    }
}

#endif // GUI_LAYOUT_NAME_IMPLEMENTATION
