# Zid

Zid is a Content Identifier (CID) Trie implementation in Zig.

## Features

- Trie structure for fast access to identifiers based on their byte values.
- Proper manages memory allocation and deallocation.
- Custom error types for better error reporting and handling.

## Building

1. Get the Zig compiler appropriate to your distribution (Generally, if you are
   sane, `nix-shell -p zig`) will do the trick.)
2. Clone the project
3. `zig build` or `zig build-exe src/main.zig` (former is recommended, but
   doesn't matter)

## Usage

<!-- deno-fmt-ignore-start -->

> [!CAUTION]
> Zid, for the time being, should be considered highly unstable and must be
> avoided in actual projects, unless you know what you are doing.

<!-- deno-fmt-ignore-end -->

### Adding Identifiers

To add an identifier to the trie, use the `add` method. Pass the identifier as a
byte slice (i.e. `[]u8`):

```zig
try trie.add("your_identifier_here");
```

### Searching for Identifiers

To search for an identifier in the trie, use the lookup method. Again, pass the
identifier as a byte slice:

```zig
const result = try trie.lookup("identifier_to_search");
```

## FAQ

[IPFS docs]: https://docs.ipfs.tech/concepts/content-addressing/#what-is-a-cid

### What the hell is a CID?

See [IPFS docs]. My interpretation of a CID Trie is a tree-like data structure
used for _efficiently_ storing and retrieving identifiers, with efficiency being
the primary goal.

### Why doesn't this build?

It's my first time building a Zig project. Call it a minor friction.

## TODO

- Support for Multiple Tries
- Batch Operations
- Dynamic MaxCIDLen (it's currently a runtime constant)
- Persistence Layer
- Concurrency
