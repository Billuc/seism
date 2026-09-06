const std = @import("std");
const Args = @import("args.zig").Args;
const CmdRunner = @import("cmd.zig").CmdRunner;

pub fn main(init: std.process.Init) !void {
    const args = init.minimal.args;
    const gpa = init.gpa;
    const io = init.io;

    const arguments = Args.parse(args);
    std.debug.print("{s}\n", .{arguments.program});

    const dir = std.Io.Dir.cwd();
    // defer dir.close(io);
    const file = try dir.openFile(io, "test.conf", .{ .allow_directory = false });
    defer file.close(io);

    var buffer: [1024]u8 = undefined;
    const readBytes = try file.readPositionalAll(io, &buffer, 0);

    if (readBytes > 0) {
        var iter = std.mem.splitAny(u8, buffer[0..readBytes], "\n");
        while (iter.next()) |line| {
            var runner = CmdRunner.fromCommand(gpa, line) catch continue;
            defer runner.deinit();
            try runner.runAndPrint(io);
        }
    }

    // const result = try std.process.run(gpa, io, .{ .argv = argv });
    // defer gpa.free(result.stderr);
    // defer gpa.free(result.stdout);

    // std.debug.print("{s}\n", .{result.stdout});
    // std.debug.print("{s}\n", .{result.stderr});
}
