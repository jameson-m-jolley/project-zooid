const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //LIB__________________________________________________________________________

    const zooid_module = b.createModule(.{
        .root_source_file = b.path("src/lib/zooid.zig"),
        .target = target,
        .optimize = optimize,
    });

    const dep_curl = b.dependency("curl", .{});
    zooid_module.addImport("curl", dep_curl.module("curl"));
    // we make the whole thing as a shard lib so that it becomes a tool as well as a lib that others can estend
    // Assuming `zooid_mod` is your library module:
    zooid_module.link_libc = true;

    const sqlite_dep = b.dependency("sqlite_c", .{});

    // 1. Translate sqlite3.h into a Zig module
    const translate_sqlite = b.addTranslateC(.{
        .root_source_file = sqlite_dep.path("sqlite3.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    // 2. Create the module and attach sqlite3.c directly to it
    const sqlite_c_mod = translate_sqlite.createModule();
    sqlite_c_mod.addIncludePath(sqlite_dep.path("."));
    sqlite_c_mod.addCSourceFile(.{
        .file = sqlite_dep.path("sqlite3.c"),
        .flags = &.{
            "-DSQLITE_DQS=0",
            "-DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1",
            "-DSQLITE_USE_ALLOCA=1",
            "-DSQLITE_THREADSAFE=1",
        },
    });

    // 2. Expose the translated header to your module as "c"
    zooid_module.addImport("sqlite", sqlite_c_mod);

    const lib = b.addLibrary(.{
        .name = "zooid",
        .linkage = .dynamic,
        .root_module = zooid_module,
    });

    b.installArtifact(lib);

    // Creates an executable that will run `test` blocks from the provided module.
    // Here `mod` needs to define a target, which is why earlier we made sure to
    // set the releative field.
    const lib_tests = b.addTest(.{
        .root_module = zooid_module,
    });

    // A run step that will run the test executable.
    const run_lib_tests = b.addRunArtifact(lib_tests);

    // shared deps _________________________________________________________________________________
    const args_dep = b.dependency("args", .{
        .target = target,
        .optimize = optimize,
    });

    // UI___________________________________________________________________________________________
    const tui = b.addExecutable(.{
        .name = "zooid_ui",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/ui/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "libzooid", .module = zooid_module },
            },
        }),
    });

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library
    tui.root_module.linkLibrary(raylib_artifact);
    tui.root_module.addImport("raylib", raylib);
    tui.root_module.addImport("raygui", raygui);
    b.installArtifact(tui);
    tui.root_module.addImport("args", args_dep.module("args"));
    const run_tui_step = b.step("run-ui", "Run the ui app");

    const run_tui = b.addRunArtifact(tui);
    run_tui_step.dependOn(&run_tui.step);

    run_tui.step.dependOn(b.getInstallStep());

    run_tui.addPassthruArgs();
    const tui_tests = b.addTest(.{
        .root_module = tui.root_module,
    });

    const run_tui_tests = b.addRunArtifact(tui_tests);
    // CLI___________________________________________________________________________________________

    const cli = b.addExecutable(.{
        .name = "zooid_cli",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/cli/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "libzooid", .module = zooid_module },
            },
        }),
    });
    b.installArtifact(cli);
    cli.root_module.addImport("args", args_dep.module("args"));
    const run_cli_step = b.step("run-cli", "Run the cli app");

    const run_cli = b.addRunArtifact(cli);
    run_cli_step.dependOn(&run_cli.step);

    run_cli.step.dependOn(b.getInstallStep());

    run_cli.addPassthruArgs();

    const cli_tests = b.addTest(.{
        .root_module = cli.root_module,
    });

    // A run step that will run the second test executable.
    const run_cli_tests = b.addRunArtifact(cli_tests);

    //FULL TEST STEP_________________________________________________________________________________
    // A top level step for running all tests. dependOn can be called multiple
    // times and since the two run steps do not depend on one another, this will
    // make the two of them run in parallel.
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_lib_tests.step);
    test_step.dependOn(&run_tui_tests.step);
    test_step.dependOn(&run_cli_tests.step);
}
