/*******************************************************************************************
*
*   Main  v1.0.0 - Tool Description
*
*   MODULE USAGE:
*       #define GUI_MAIN _IMPLEMENTATION
*       #include "gui_main .h"
*
*       INIT: GuiMain State state = InitGuiMain ();
*       DRAW: GuiMain (&state);
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

#ifndef GUI_MAIN _H
#define GUI_MAIN _H

typedef struct {
    // Define anchors
    Vector2 anchor01;            // ANCHOR ID:1
    Vector2 anchor02;            // ANCHOR ID:2
    
    // Define controls variables
    bool TextBox002EditMode;
    char TextBox002Text[128];            // TextBox: TextBox002
    bool Spinner005EditMode;
    int Spinner005Value;            // Spinner: Spinner005
    bool TextBox005EditMode;
    char TextBox005Text[128];            // TextBox: TextBox005
    int ListView008ScrollIndex;
    int ListView008Active;            // ListView: ListView008
    bool TextBox009EditMode;
    char TextBox009Text[128];            // TextBox: TextBox009
    int ListView011ScrollIndex;
    int ListView011Active;            // ListView: ListView011
    Rectangle ScrollPanel017ScrollView;
    Vector2 ScrollPanel017ScrollOffset;
    Vector2 ScrollPanel017BoundsOffset;            // ScrollPanel: ScrollPanel017

    // Define rectangles
    Rectangle layoutRecs[20];

    // Custom state variables (depend on development software)
    // NOTE: This variables should be added manually if required

} GuiMain State;

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
GuiMain State InitGuiMain (void);
void GuiMain (GuiMain State *state);
static void Button003();                // Button: Button003 logic
static void Button019();                // Button: Button019 logic
static void Button015();                // Button: Button015 logic
static void Button019();                // Button: Button019 logic

#ifdef __cplusplus
}
#endif

#endif // GUI_MAIN _H

/***********************************************************************************
*
*   GUI_MAIN  IMPLEMENTATION
*
************************************************************************************/
#if defined(GUI_MAIN _IMPLEMENTATION)

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
GuiMain State InitGuiMain (void)
{
    GuiMain State state = { 0 };

    // Init anchors
    state.anchor01 = (Vector2){ 24, 24 };            // ANCHOR ID:1
    state.anchor02 = (Vector2){ 280, 32 };            // ANCHOR ID:2
    
    // Initilize controls variables
    state.TextBox002EditMode = false;
    strcpy(state.TextBox002Text, "type msg");            // TextBox: TextBox002
    state.Spinner005EditMode = false;
    state.Spinner005Value = 0;            // Spinner: Spinner005
    state.TextBox005EditMode = false;
    strcpy(state.TextBox005Text, "search");            // TextBox: TextBox005
    state.ListView008ScrollIndex = 0;
    state.ListView008Active = 0;            // ListView: ListView008
    state.TextBox009EditMode = false;
    strcpy(state.TextBox009Text, "SAMPLE TEXT");            // TextBox: TextBox009
    state.ListView011ScrollIndex = 0;
    state.ListView011Active = 0;            // ListView: ListView011
    state.ScrollPanel017ScrollView = (Rectangle){ 0, 0, 0, 0 };
    state.ScrollPanel017ScrollOffset = (Vector2){ 0, 0 };
    state.ScrollPanel017BoundsOffset = (Vector2){ 0, 0 };            // ScrollPanel: ScrollPanel017

    // Init controls rectangles
    state.layoutRecs[0] = (Rectangle){ state.anchor01.x + 0, state.anchor01.y + 8, 240, 688 };// GroupBox: GroupBox000
    state.layoutRecs[1] = (Rectangle){ state.anchor02.x + 0, state.anchor02.y + 0, 800, 688 };// GroupBox: GroupBox001
    state.layoutRecs[2] = (Rectangle){ state.anchor02.x + 8, state.anchor02.y + 648, 664, 32 };// TextBox: TextBox002
    state.layoutRecs[3] = (Rectangle){ state.anchor02.x + 688, state.anchor02.y + 648, 96, 32 };// Button: Button003
    state.layoutRecs[4] = (Rectangle){ state.anchor02.x + 624, state.anchor02.y + 16, 160, 32 };// Spinner: Spinner005
    state.layoutRecs[5] = (Rectangle){ state.anchor02.x + 16, state.anchor02.y + 16, 216, 32 };// TextBox: TextBox005
    state.layoutRecs[6] = (Rectangle){ state.anchor02.x + 16, state.anchor02.y + 56, 768, 16 };// Line: Line006
    state.layoutRecs[7] = (Rectangle){ state.anchor02.x + 8, state.anchor02.y + 624, 776, 12 };// Line: Line007
    state.layoutRecs[8] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 96, 224, 96 };// ListView: ListView008
    state.layoutRecs[9] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 56, 224, 32 };// TextBox: TextBox009
    state.layoutRecs[10] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 248, 224, 16 };// Line: Line010
    state.layoutRecs[11] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 312, 224, 176 };// ListView: ListView011
    state.layoutRecs[12] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 272, 224, 32 };// DummyRec: DummyRec012
    state.layoutRecs[13] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 16, 224, 32 };// DummyRec: DummyRec013
    state.layoutRecs[14] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 496, 224, 32 };// Button: Button019
    state.layoutRecs[15] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 200, 224, 40 };// Button: Button015
    state.layoutRecs[16] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 536, 224, 16 };// Line: Line016
    state.layoutRecs[17] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 592, 224, 96 };// ScrollPanel: ScrollPanel017
    state.layoutRecs[18] = (Rectangle){ state.anchor01.x + 8, state.anchor01.y + 552, 96, 32 };// DummyRec: DummyRec018
    state.layoutRecs[19] = (Rectangle){ state.anchor01.x + 112, state.anchor01.y + 552, 120, 32 };// Button: Button019

    // Custom variables initialization

    return state;
}
// Button: Button003 logic
static void Button003()
{
    // TODO: Implement control logic
}
// Button: Button019 logic
static void Button019()
{
    // TODO: Implement control logic
}
// Button: Button015 logic
static void Button015()
{
    // TODO: Implement control logic
}
// Button: Button019 logic
static void Button019()
{
    // TODO: Implement control logic
}


void GuiMain (GuiMain State *state)
{
    // Const text
    const char *GroupBox000Text = "SAMPLE TEXT";    // GROUPBOX: GroupBox000
    const char *GroupBox001Text = "messages";    // GROUPBOX: GroupBox001
    const char *Button003Text = " >>>";    // BUTTON: Button003
    const char *ListView008Text = "ONE;TWO;THREE";    // LISTVIEW: ListView008
    const char *ListView011Text = "ONE;TWO;THREE";    // LISTVIEW: ListView011
    const char *DummyRec012Text = "friends";    // DUMMYREC: DummyRec012
    const char *DummyRec013Text = "zooid colonys";    // DUMMYREC: DummyRec013
    const char *Button019Text = "settings";    // BUTTON: Button019
    const char *Button015Text = "settings";    // BUTTON: Button015
    const char *DummyRec018Text = "zooid_logs";    // DUMMYREC: DummyRec018
    const char *Button019Text = "app settings";    // BUTTON: Button019
    
    // Draw controls
    GuiGroupBox(state->layoutRecs[0], GroupBox000Text);
    GuiGroupBox(state->layoutRecs[1], GroupBox001Text);
    if (GuiTextBox(state->layoutRecs[2], state->TextBox002Text, 128, state->TextBox002EditMode)) state->TextBox002EditMode = !state->TextBox002EditMode;
    if (GuiButton(state->layoutRecs[3], Button003Text)) Button003(); 
    if (GuiSpinner(state->layoutRecs[4], Spinner005Text, &state->Spinner005Value, 0, 100, state->Spinner005EditMode)) state->Spinner005EditMode = !state->Spinner005EditMode;
    if (GuiTextBox(state->layoutRecs[5], state->TextBox005Text, 128, state->TextBox005EditMode)) state->TextBox005EditMode = !state->TextBox005EditMode;
    GuiLine(state->layoutRecs[6], Line006Text);
    GuiLine(state->layoutRecs[7], Line007Text);
    GuiListView(state->layoutRecs[8], ListView008Text, &state->ListView008ScrollIndex, &state->ListView008Active);
    if (GuiTextBox(state->layoutRecs[9], state->TextBox009Text, 128, state->TextBox009EditMode)) state->TextBox009EditMode = !state->TextBox009EditMode;
    GuiLine(state->layoutRecs[10], Line010Text);
    GuiListView(state->layoutRecs[11], ListView011Text, &state->ListView011ScrollIndex, &state->ListView011Active);
    GuiDummyRec(state->layoutRecs[12], DummyRec012Text);
    GuiDummyRec(state->layoutRecs[13], DummyRec013Text);
    if (GuiButton(state->layoutRecs[14], Button019Text)) Button019(); 
    if (GuiButton(state->layoutRecs[15], Button015Text)) Button015(); 
    GuiLine(state->layoutRecs[16], Line016Text);
    GuiScrollPanel((Rectangle){state->layoutRecs[17].x, state->layoutRecs[17].y, state->layoutRecs[17].width - state->ScrollPanel017BoundsOffset.x, state->layoutRecs[17].height - state->ScrollPanel017BoundsOffset.y }, ScrollPanel017Text, state->layoutRecs[17], &state->ScrollPanel017ScrollOffset, &state->ScrollPanel017ScrollView);
    GuiDummyRec(state->layoutRecs[18], DummyRec018Text);
    if (GuiButton(state->layoutRecs[19], Button019Text)) Button019(); 
}

#endif // GUI_MAIN _IMPLEMENTATION
