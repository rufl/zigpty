const std = @import("std");
const builtin = @import("builtin");

pub const Pid = if (builtin.os.tag == .windows) u32 else std.posix.pid_t;

pub const ExitInfo = struct {
    exit_code: i32,
    signal_code: i32,
};

pub const ChildStats = struct {
    pid: Pid,
    name: [32]u8,
    name_len: u8,
    rss_bytes: u64,
    cpu_user_us: u64,
    cpu_sys_us: u64,

    pub fn nameSlice(self: *const ChildStats) []const u8 {
        return self.name[0..self.name_len];
    }
};

pub const Stats = struct {
    pid: Pid,
    cwd: ?[]const u8,
    rss_bytes: u64,
    cpu_user_us: u64,
    cpu_sys_us: u64,
    count: u32,
    children: []const ChildStats,

    pub fn deinit(self: *Stats, allocator: std.mem.Allocator) void {
        if (self.children.len > 0) allocator.free(self.children);
        self.children = &[_]ChildStats{};
    }
};
