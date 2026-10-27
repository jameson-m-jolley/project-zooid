# cheadertozigraylib.md

Notes on translating rguilayout-generated C headers to Zig raygui for
project-Harpocrates.

## Source reference

C reference headers live in this directory:
- `src/ui/raygui_c/gui_main.h` (originally `src/ui/gui_main .h`, renamed to drop the stray space)
- `src/ui/raygui_c/login.h`
- `src/ui/raygui_c/settings.h`

Translated Zig modules:
- `src/ui/main_dashbord.zig` (from `gui_main.h`)
- `src/ui/login.zig` (from `login.h`)
- `src/ui/settings.zig` (from `settings.h`)

## Architecture

UI state and navigation live in two factory functions that each take a
`comptime` anytype config struct:

### `view.zig` — `gen_view(comptime Config: type) type`

Returns a struct bundling view state, navigation, and drawing:

```zig
pub const View = view_lib.gen_view(@TypeOf(view_lib.view_settings));
var view = View.init(config, allocator);
defer view.deinit();

// Navigation
try view.goto(view_lib.views.login);
if (view.back()) {}        // pops last view, false if empty
const cur = view.current(); // ?view.views, null if empty

// Drawing
view.draw();
```

Fields/methods:
- `config: Config` — the comptime config struct passed to `gen_view`
- `view_stack: std.ArrayList(views)` — navigation stack
- `allocator: std.mem.Allocator`
- `init(config, allocator) @This()`
- `deinit(self: *@This()) void`
- `draw(self: *@This()) void` — draws the current view
- `goto(self: *@This(), v: views) !void` — pushes a view onto the stack
- `back(self: *@This()) bool` — pops the stack, `false` if empty
- `current(self: *@This()) ?views` — topmost view, or `null`

### `controller.zig` — `gen_controller(comptime Config: type) type`

Returns a simple controller struct (navigation moved to `view.zig`):

```zig
pub const Controller = controller_lib.gen_controller(@TypeOf(view_lib.view_settings));
var controller = Controller.init(config);
```

Fields/methods:
- `config: Config`
- `init(config) @This()`

## Issues found during C → Zig raygui translation

### 1. Module namespace / naming

C headers call raygui as bare globals: `GuiGroupBox(...)`, `GuiTextBox(...)`,
etc. raylib-zig namespaces them under `raygui` in snake_case:
- `GuiGroupBox` → `raygui.groupBox`
- `GuiTextBox` → `raygui.textBox`
- `GuiButton` → `raygui.button`
- `GuiSpinner` → `raygui.spinner`
- `GuiLine` → `raygui.line`
- `GuiListView` → `raygui.listView`
- `GuiDummyRec` → `raygui.dummyRec`
- `GuiScrollPanel` → `raygui.scrollPanel`
- `GuiWindowBox` → `raygui.windowBox`
- `GuiLabelButton` → `raygui.labelButton`
- `GuiLabel` → `raygui.label`

### 2. Function signature differences

| C (raygui.h) | raylib-zig `raygui` | Note |
|---|---|---|
| `GuiTextBox(bounds, text, size, editMode)` | `textBox(bounds, text: [:0]u8, editMode: bool) bool` | `size` dropped; text is sentinel slice |
| `GuiSpinner(...)` | `spinner(...) i32` | Returns `i32`, compare `> 0` |
| `GuiWindowBox(...)` | `windowBox(...) i32` | Returns `i32`, compare `> 0` |
| `GuiGroupBox` / `GuiLine` / `GuiDummyRec` / `GuiScrollPanel` / `GuiListView` / `GuiLabel` | return `i32` | Discard with `_ =` |

Zig forbids ignoring non-void return values; unused calls must be prefixed
with `_ =`.

### 3. Text values as static consts (not mutable buffers)

C headers use mutable `char TextBoxNNNText[128]` buffers initialized with
`strcpy`. Those mutable buffers are removed entirely — text never changes
at runtime.

Text box values are package-level `[:0]const u8` consts passed through
`@constCast` to `raygui.textBox` (which takes mutable `[:0]u8`):

```zig
const TextBox002Text: [:0]const u8 = "type msg";
// ...
raygui.textBox(state.layout_recs[2], @constCast(TextBox002Text), state.var_text_box_002_edit_mode)
```

No `[128:0]u8`, no `std.mem.copySentinel`, no per-instance text fields,
no runtime initialization.

`\0` is not a valid escape in this Zig; string literals already carry the
sentinel.

### 4. Generated-C bugs present in the headers

- `gui_main.h`: `static void Button019();` declared twice; references
  undeclared `Spinner005Text`, `Line*`, `ScrollPanel017Text`.
- Zig substitutes `""` or appropriate literals for missing identifiers.

### 5. Header guards

C header guards have embedded spaces (e.g. `GUI_MAIN _H`). Compiles in C
but unconventional; Zig has no equivalent concern.

### 6. `ArrayList.init` in Zig 0.17

`std.ArrayList(T).init(allocator)` does not exist. Use `.empty` const and
`deinit(self.allocator)`:

```zig
var stack = std.ArrayList(views).empty;
defer stack.deinit(allocator);
// ...
try stack.append(allocator, some_view);
```

## Build command

```
zig build run-ui -- -s
```

Compiles cleanly and launches a raylib window drawing the translated
raygui layouts.
