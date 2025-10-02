# Splay Tree

Self-adjusting binary search tree implementation for MoonBit. The tree splays
(nodes rotate towards the root) on every access so that recently used keys stay
close to the top, providing excellent practical performance for skewed
workloads.

## Highlights
- Generic over key and value types (keys must implement `Compare`).
- `insert`, `get`, `contains`, `remove`, and `clear` operations provided.
- Automatically keeps the most recently accessed key at the root.

## Quick Start
```moonbit
test "README basic usage" {
  let tree : SplayTree[Int, String] = SplayTree::new()
  tree.insert(42, "answer")
  tree.insert(7, "lucky")
  assert_eq(tree.get(7), Some("lucky"))
  tree.insert(15, "middle")
  assert_eq(tree.remove(42), true)
  assert_eq(tree.contains(42), false)
  assert_eq(tree.len(), 2)

  tree.clear()
  assert_eq(tree.is_empty(), true)
}
```

## API Overview
- `SplayTree::new()` – create an empty tree.
- `insert(key, value)` – add or update a key.
- `get(key)` – fetch the value and splay the node to the root.
- `contains(key)` – boolean membership check (also splays).
- `remove(key)` – delete a key when present.
- `clear()` – remove everything while keeping the structure reusable.
- `len()` / `is_empty()` – observe current size.

> ℹ️ Splaying keeps the tree balanced enough for amortized `O(log n)` access
> while making repeated queries for the same keys very fast.
