# Persistent Treap

A persistent, randomized balanced binary search tree for MoonBit. Each update
returns a new tree version and keeps old versions alive for later queries.

## Highlights
- Persistent updates: `insert` and `remove` return new tree instances.
- Deterministic priorities keep results reproducible across runs.
- `Compare`-based keys with generic values.

## Quick Start
```moonbit
///|
test "README persistent treap usage" {
  let t0 : PersistentTreap[Int, String] = PersistentTreap::new()
  let t1 = t0.insert(5, "five")
  let t2 = t1.insert(2, "two")
  let t3 = t2.insert(5, "FIVE")
  assert_eq(t0.len(), 0)
  assert_eq(t1.get(5), Some("five"))
  assert_eq(t2.contains(2), true)
  assert_eq(t3.get(5), Some("FIVE"))

  let (t4, removed) = t3.remove(2)
  assert_eq(removed, true)
  assert_eq(t3.contains(2), true)
  assert_eq(t4.contains(2), false)
}
```

## API Overview
- `PersistentTreap::new()` – construct an empty treap.
- `insert(key, value)` – return a new treap with the value set.
- `get(key)` – retrieve a value from the current version.
- `contains(key)` – membership query on the current version.
- `remove(key)` – return a new treap and whether removal occurred.
- `clear()` – return an empty treap with the same RNG state.
- `len()` / `is_empty()` – observe current size.
