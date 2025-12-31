# Scapegoat Tree

Self-balancing binary search tree implementation for MoonBit based on the
scapegoat tree strategy. The tree keeps weight balance by rebuilding subtrees
when an insertion creates an imbalance, and it occasionally rebuilds the whole
structure after many deletions.

## Highlights
- Generic over key and value types (keys must implement `Compare`).
- `insert`, `get`, `contains`, `remove`, and `clear` operations provided.
- Subtree rebuilds keep operations efficient without storing explicit height
  metadata.

## Quick Start
```moonbit
///|
test "README scapegoat usage" {
  let tree : ScapegoatTree[Int, String] = ScapegoatTree::new()
  tree.insert(8, "eight")
  tree.insert(3, "three")
  tree.insert(10, "ten")
  assert_eq(tree.len(), 3)
  assert_eq(tree.get(3), Some("three"))
  assert_eq(tree.contains(5), false)
  tree.insert(3, "THREE")
  assert_eq(tree.get(3), Some("THREE"))
  assert_eq(tree.remove(8), true)
  assert_eq(tree.contains(8), false)
  tree.clear()
  assert_eq(tree.is_empty(), true)
}
```

## API Overview
- `ScapegoatTree::new()` – create an empty tree.
- `insert(key, value)` – add or update a key.
- `get(key)` – fetch the value for a key.
- `contains(key)` – boolean membership check.
- `remove(key)` – delete a key when present.
- `clear()` – remove everything while keeping the structure reusable.
- `len()` / `is_empty()` – observe current size.

> ℹ️ Scapegoat trees rebalance by rebuilding unbalanced subtrees, keeping the
> structure efficient without extra per-node balancing metadata.

