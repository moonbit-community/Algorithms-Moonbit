# Red-Black Tree

Left-leaning red-black tree (LLRB) for MoonBit. This structure maintains a
balanced binary search tree with guaranteed logarithmic operations by encoding
2-3 tree invariants using red/black links.

## Highlights
- Generic in both key and value types; requires `Compare` on keys.
- Supports `insert`, `get`, `contains`, `remove`, `clear`, `len`, and `is_empty`.
- Deterministic rotations and color flips keep balancing predictable.

## Quick Start
```moonbit
///|
test "README red-black tree usage" {
  let tree : RedBlackTree[Int, String] = RedBlackTree::new()
  tree.insert(10, "ten")
  tree.insert(5, "five")
  tree.insert(15, "fifteen")
  assert_eq(tree.len(), 3)
  assert_eq(tree.get(5), Some("five"))
  assert_eq(tree.contains(7), false)
  tree.insert(5, "FIVE")
  assert_eq(tree.get(5), Some("FIVE"))
  assert_eq(tree.remove(10), true)
  assert_eq(tree.contains(10), false)
  tree.clear()
  assert_eq(tree.is_empty(), true)
}
```

## API Overview
- `RedBlackTree::new()` – construct an empty tree.
- `insert(key, value)` – upsert a key/value pair.
- `get(key)` – retrieve the stored value or `None`.
- `contains(key)` – boolean membership query.
- `remove(key)` – delete the entry if present.
- `clear()` – empty the structure while retaining capacity.
- `len()` / `is_empty()` – observe current occupancy.
