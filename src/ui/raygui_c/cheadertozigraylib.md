# cheadertozigraylib.md

Notes on translating the rguilayout-generated C header (`gui_main.h`) to Zig
raygui for project-Harpocrates (`src/ui/main_dashbord.zig`).

## Source reference

The C reference header was moved into this directory:
`src/ui/raygui_c/gui_main.h` (originally `src/ui/gui_main .h`, renamed to
drop the stray space in the filename).

The translated Zig module lives at `src/ui/main_dashbord.zig` and imports the
raylib-zig `raygui` module.

## Issues found during C → Zig raygui translation

### 1. Module namespace / naming
The C header calls raygui functions as bare globals:
`GuiGroupBox(...)`, `GuiTextBox(...)`, `GuiButton(...)`, etc.

In raylib-zig, raygui functions are namespaced under the `raygui` module and
use snake_case:
- `GuiGroupBox` → `raygui.groupBox`
- `GuiTextBox` → `raygui.textBox`
- `GuiButton` → `raygui.button`
- `GuiSpinner` → `raygui.spinner`
- `GuiLine` → `raygui.line`
- `GuiListView` → `raygui.listView`
- `GuiDummyRec` → `raygui.dummyRec`
- `GuiScrollPanel` → `raygui.scrollPanel`

### 2. Function signature differences
| C (raygui.h) | raylib-zig `raygui` | Note |
|---|---|---|
| `GuiTextBox(bounds, text, size, editMode)` | `textBox(bounds, text: [:0]u8, editMode: bool) bool` | `size` param dropped; text is a sentinel-terminated slice |
| `GuiSpinner(bounds, text, value, min, max, editMode)` | `spinner(...) i32` | Returns `i32`, not `bool`; must compare `> 0` in `if` |
| `GuiGroupBox` / `GuiLine` / `GuiDummyRec` / `GuiScrollPanel` / `GuiListView` | return `i32` | Zig requires all non-void return values to be used; discard with `_ =` |

Because Zig forbids ignoring non-void return values, every call that isn't
used in a condition must be prefixed with `_ =`.

### 3. Text values as static consts (not mutable buffers)
The C struct uses mutable `char TextBox002Text[128]` buffers initialized with
`strcpy`. In this Zig translation those mutable buffers were removed entirely
because the text never changes at runtime.

Text box values are package-level static consts with exact sentinel size:

```zig
const TextBox002Text: [:0]const u8 = "type msg";
const TextBox005Text: [:0]const u8 = "search";
const TextBox009Text: [:0]const u8 = "SAMPLE TEXT";
```

They are passed directly to `raygui.textBox(..., text, editMode)`. Because this
raylib-zig `raygui.textBox` signature takes a mutable `[:0]u8` (even though it
only reads), each const is cast with `@constCast` at the call site:

```zig
raygui.textBox(state.layout_recs[2], @constCast(TextBox002Text), state.var_text_box_002_edit_mode)
```

No `[128:0]u8`, no `std.mem.copySentinel`, no per-instance text fields, no
runtime initialization in `init_gui_main`.

\0 is not a valid escape in this Zig; string literals already carry the
sentinel.

### 4. Generated-C bugs present in the header
The rguilayout-generated C header contains defects that had to be worked
around in Zig:

- `static void Button019();` is declared twice (duplicate forward declaration
  and duplicate definition).
- The `GuiMain` implementation references undeclared identifiers:
  `Spinner005Text`, `Line006Text`, `Line007Text`, `Line010Text`,
  `Line016Text`, `ScrollPanel017Text`. The Zig version substitutes `""` or
  appropriate literals for these.

### 5. Header guard
The C header guard is `GUI_MAIN _H` (with embedded spaces). It compiles in C
but is unconventional; the Zig side has no equivalent concern.

### 6. State re-initialization each frame
`start_ui` in `src/ui/main.zig` calls `init_gui_main` inside the render loop,
resetting control state (edit mode, text, scroll) every frame. This is a
pre-existing design issue in the translation, not a compile error.

## Build command
```
zig build run-ui -- -s
```

Result: compiles cleanly and launches an 800x450 raylib window drawing the
translated raygui layout.

---

## Login (`login.h` → `src/ui/login.zig`)

### Source reference

`src/ui/raygui_c/login.h` (unchanged name, moved into `src/ui/raygui_c/`).

Translated Zig module: `src/ui/login.zig`.

### Idiomatic struct pattern
### Idiomatic struct pattern

Both `main_dashbord.zig` and `login.zig` bundle state and behavior into a
single struct with methods:

```zig
pub const MainDashbord = struct {
    // state fields...
    pub fn init(allocator: std.mem.Allocator, view_width: f32, view_height: f32) MainDashbord { ... }
    pub fn deinit(self: MainDashbord) void { ... }
    pub fn draw(self: *MainDashbord) void { ... }
};

pub const LoginGui = struct {
    // state fields...
    pub fn init(allocator: std.mem.Allocator) LoginGui { ... }
    pub fn deinit(self: LoginGui) void { ... }
    pub fn draw(self: *LoginGui) void { ... }
};
```

Usage in `src/ui/main.zig`:

```zig
var main_dash = main_v.MainDashbord.init(allocator, screenWidth, screenHeight);
defer main_dash.deinit();

var login_gui = login_v.LoginGui.init(allocator);
defer login_gui.deinit();

// ...
main_dash.draw();
login_gui.draw();
```

Same pattern as `main_dashbord.zig`: package-level `[:0]const u8` consts passed
through `@constCast` to `raygui.textBox` (which takes `[:0]u8`):

through `@constCast` to `raygui.textBox` (which takes `[:0]u8`):

```zig
const TextBox002Text: [:0]const u8 = "SAMPLE TEXT";
const TextBox005Text: [:0]const u8 = "SAMPLE TEXT";
// ...
raygui.textBox(self.layout_recs[2], @constCast(TextBox002Text), self.text_box_002_edit_mode)
```

#### 3. `label` / `groupBox` / `scrollPanel` return `i32`

Discard with `_ =`.

#### 4. `scrollPanel` text parameter

Takes `?[*:0]const u8` (nullable). Pass `null` when no label is needed.

#### 5. Layout rectangles match C exactly

Raw C values with no scaling; `allocator` accepted but unused (no heap
allocations in this module).

---

## Settings (`settings.h` → `src/ui/settings.zig`)

### Source reference

`src/ui/raygui_c/settings.h` (unchanged name, moved into `src/ui/raygui_c/`).

Translated Zig module: `src/ui/settings.zig`.

### Idiomatic struct pattern

Same pattern as `main_dashbord.zig` and `login.zig`: a single struct bundling
state and behavior:

```zig
pub const SettingsGui = struct {
    // state fields...
    pub fn init(allocator: std.mem.Allocator) SettingsGui { ... }
    pub fn deinit(self: SettingsGui) void { ... }
    pub fn draw(self: *SettingsGui) void { ... }
};
```

Usage in `src/ui/main.zig`:

```zig
var settings_gui = settings_v.SettingsGui.init(allocator);
defer settings_gui.deinit();

// ...
settings_gui.draw();
```

### Issues found during settings.h → Zig raygui translation

#### 1. `windowBox` returns `i32`, not `bool`

C: `state->WindowBox000Active = !GuiWindowBox(...)`.

Zig `raygui.windowBox` returns `i32`, so the negation must compare first:

```zig
self.window_box_000_active = !(raygui.windowBox(...) > 0);
```

#### 2. Text values as static consts

Package-level `[:0]const u8` consts passed through `@constCast` to
`raygui.textBox` (which takes `[:0]u8`):

```zig
const TextBox017Text: [:0]const u8 = "SAMPLE TEXT";
// ...
raygui.textBox(self.layout_recs[1], @constCast(TextBox017Text), self.text_box_017_edit_mode)
```

#### 3. `dummyRec` / `scrollPanel` return `i32`

Discard with `_ =`.

#### 4. `scrollPanel` text parameter

Takes `?[*:0]const u8` (nullable). Pass `null` when no label is needed.

#### 5. Layout rectangles match C exactly

Raw C values with no scaling; `allocator` accepted but unused (no heap
allocations in this module).
