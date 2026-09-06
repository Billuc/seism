const std = @import("std");

pub const Args = struct {
    program: []const u8,

    pub fn parse(args: std.process.Args) Args {
        var iterator = args.iterate();
        var i: u8 = 0;
        var program: []const u8 = undefined;

        defer iterator.deinit();

        while (iterator.next()) |arg| : (i += 1) {
            if (i == 0) {
                program = arg;
            }
        }

        return Args{ .program = program };
    }
};
