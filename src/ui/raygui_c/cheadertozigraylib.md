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

### 3. Mutable text box buffers (required for all text boxes)

Text boxes that accept user input must use mutable per-instance `[128:0]u8`
buffers initialized at creation — not package-level `[:0]const u8` literals.

**Rules (must be followed for every text box):**

1. **Zero-fill once at init** with `@splat('\x00')` before any use. `var self = undefined`
   leaves trailing bytes as uninitialized garbage, which raygui renders as repeated `?`
   characters.
2. **Never re-splat in `draw`** — that wipes user edits and makes text input impossible.
3. **Never `@constCast` a `[:0]const u8` literal** for `raygui.textBox` — raygui writes
   keystrokes directly into the buffer; writing to read-only const memory segfaults.
4. **Pass `&self.text_box_NNN_text` directly** to `raygui.textBox` (no `@constCast`).

**Pattern (from `login.zig`):**

```zig
// Struct field
text_box_002_text: [128:0]u8,

// In init — zero-fill once at creation
self.text_box_002_text = @splat('\x00');

// In draw — pass mutable buffer directly, no copySentinel, no @constCast
if (raygui.textBox(self.layout_recs[2], &self.text_box_002_text, self.text_box_002_edit_mode)) ...
```

This prevents:
- **Segfaults** (writing keystrokes to read-only const memory via `@constCast`)
- **Repeated `?` characters** (reading uninitialized garbage trailing bytes)

**Applies to:** `login.zig` (done), `main_dashbord.zig` (done), `settings.zig` (done).

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
