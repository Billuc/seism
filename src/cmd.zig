const std = @import("std");

pub const CmdRunner = struct {
    arena: std.heap.ArenaAllocator,
    argv: std.ArrayList([]const u8),

    pub fn deinit(self: *CmdRunner) void {
        self.argv.deinit(self.arena.allocator());
        self.arena.deinit();
    }

    pub fn fromCommand(allocator: std.mem.Allocator, command: []const u8) !CmdRunner {
        var arena = std.heap.ArenaAllocator.init(allocator);
        errdefer arena.deinit();
        const arena_allocator = arena.allocator();

        const trimmedCmd = std.mem.trim(u8, command, " \t");
        if (trimmedCmd.len == 0) {
            return error.EmptyCommand;
        }

        var argvIter = std.mem.splitScalar(u8, trimmedCmd, ' ');
        var argvVec = std.ArrayList([]const u8).empty;
        errdefer argvVec.deinit(arena_allocator);

        while (argvIter.next()) |w| {
            const argument_copy = try arena_allocator.dupe(u8, w);
            try argvVec.append(arena_allocator, argument_copy);
        }

        return CmdRunner{
            .arena = arena,
            .argv = argvVec,
        };
    }

    pub fn fromArgs(allocator: std.mem.Allocator, argv: []const []const u8) !CmdRunner {
        if (argv.len == 0) {
            return error.EmptyCommand;
        }

        var arena = std.heap.ArenaAllocator.init(allocator);
        errdefer arena.deinit();
        const arena_allocator = arena.allocator();

        var argvVec = std.ArrayList([]const u8).empty;
        errdefer argvVec.deinit(arena_allocator);

        for (argv) |w| {
            const argument_copy = try arena_allocator.dupe(u8, w);
            try argvVec.append(arena, argument_copy);
        }

        return CmdRunner{ .arena = arena, .argv = argvVec };
    }

    pub fn runAndPrint(self: *CmdRunner, io: std.Io) !void {
        var allocator = self.arena.allocator();

        try std.Io.File.stdout().writeStreamingAll(io, "> ");
        for (self.argv.items) |arg| {
            try std.Io.File.stdout().writeStreamingAll(io, arg);
            try std.Io.File.stdout().writeStreamingAll(io, " ");
        }
        try std.Io.File.stdout().writeStreamingAll(io, "\n");

        const result = try std.process.run(allocator, io, .{
            .argv = self.argv.items,
        });

        defer allocator.free(result.stderr);
        defer allocator.free(result.stdout);

        if (result.stdout.len > 0) {
            std.log.info("{s}\n", .{result.stdout});
            try std.Io.File.stdout().writeStreamingAll(io, "\n");
        }
        if (result.stderr.len > 0) {
            std.log.err("{s}\n", .{result.stderr});
        }
    }
};
