pub fn gen_controller(comptime Config: type) type {
    return struct {
        config: Config,

        pub fn init(config: Config) @This() {
            return .{ .config = config };
        }
    };
}
