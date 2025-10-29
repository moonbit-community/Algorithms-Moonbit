# Treap

Randomized binary search tree for MoonBit. Each node stores a randomly assigned
priority so the structure stays balanced in expectation, while still behaving
like an ordered map keyed by `Compare` values.

## Highlights
- Generic in both key and value types; only requires `Compare` on keys.
- Supports `insert`, `get`, `contains`, `remove`, `clear`, `len`, and `is_empty`.
- Deterministic pseudo-random priorities keep the tree reproducible in tests.

## Quick Start
```moonbit
///|
test "README treap usage" {
  let treap : Treap[Int, String] = Treap::new()
  treap.insert(8, "eight")
  treap.insert(3, "three")
  treap.insert(5, "five")
  assert_eq(treap.len(), 3)
  assert_eq(treap.get(5), Some("five"))
  assert_eq(treap.contains(7), false)
  treap.insert(5, "FIVE")
  assert_eq(treap.get(5), Some("FIVE"))
  assert_eq(treap.remove(3), true)
  assert_eq(treap.contains(3), false)
  treap.clear()
  assert_eq(treap.is_empty(), true)
}
```

## API Overview
- `Treap::new()` – construct an empty treap.
- `insert(key, value)` – upsert a key/value pair.
- `get(key)` – retrieve the stored value or `None`.
- `contains(key)` – boolean membership query.
- `remove(key)` – delete the entry if present.
- `clear()` – empty the structure while retaining capacity.
- `len()` / `is_empty()` – observe current occupancy.

> ℹ️ The internal priority generator is deterministic, making results stable
> across runs while still preserving the balancing guarantees of treaps.
