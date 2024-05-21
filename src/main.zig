const std = @import("std");

pub var errCollision = std.errors.New("collisions");
pub var errNotFound = std.errors.New("not found");

pub const maxCIDLen = 20;
pub const CIDTrie = struct {
    leaves: [256]?*CIDTrie,
    end: bool,

    pub fn add(self: *CIDTrie, cid: []u8) !void {
        if (cid.len > maxCIDLen) return error.CIDTooLong;
        var trie = self;
        for (cid) |b| {
            if (trie.leaves[b] == null) {
                trie.leaves[b] = try std.heap.page_allocator.alloc(CIDTrie);
                trie.leaves[b].?.end = false;
            } else if (trie.leaves[b].?.end) {
                return errCollision;
            }
            if (cid.len == 1) {
                for (trie.leaves[b].?.leaves) |leaf| {
                    if (leaf != null) return errCollision;
                }
                trie.leaves[b].?.end = true;
            }
            trie = trie.leaves[b];
        }
    }

    pub fn lookup(self: *CIDTrie, data: []u8) ![]u8 {
        if (data.len > maxCIDLen) return error.CIDTooLong;
        if (self.leaves[data[0]] == null) return errNotFound;
        var nextLevel = self;
        var currentIndex: usize = 0;

        for (data) |b| {
            nextLevel = nextLevel.leaves[b];
            if (nextLevel.? != null and nextLevel.?.end) {
                return data[0..currentIndex];
            }
            currentIndex += 1;
        }
        return errNotFound;
    }
};

pub fn main() void {
    var allocator = std.heap.page_allocator;

    const trie = allocator.create(CIDTrie) catch |err| {
        std.debug.print("Failed to allocate memory: {}\n", .{err});
        return;
    };
    defer allocator.destroy(trie);

    // add entries
    const addResult = trie.add("hello"[0..]) catch |err| {
        std.debug.print("Failed to add 'hello': {}\n", .{err});
        return;
    };

    std.debug.print("Added 'hello': {}\n", .{addResult}); // this assumes add returns a meaningful value, alternative is to remove

    // lookup entries
    const lookupHelloResult = trie.lookup("hello"[0..]) catch |err| {
        std.debug.print("Failed to lookup 'hello': {}\n", .{err});
        return;
    };
    std.debug.print("Found 'hello': {}\n", .{lookupHelloResult});

    const lookupWorldResult = trie.lookup("world"[0..]) catch |err| {
        std.debug.print("Failed to lookup 'world': {}\n", .{err});
        return;
    };
    std.debug.print("Found 'world': {}\n", .{lookupWorldResult});

    // attempt to lookup a nonexistent entry
    const lookupNonexistentResult = trie.lookup("nonexistent"[0..]);
    if (lookupNonexistentResult) |result| {
        std.debug.print("Unexpectedly found 'nonexistent': {}\n", .{result});
    } else |err| {
        std.debug.print("Expected error for 'nonexistent': {}\n", .{err});
    }
}
