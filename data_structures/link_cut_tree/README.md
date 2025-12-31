# Link-Cut Tree

A Link-Cut Tree maintains a dynamic forest and supports fast updates and path
queries. This implementation tracks path sums over `Int` node values while
allowing you to link and cut edges on the fly.

## Highlights
- `link`, `cut`, `connected`, `set_value`, and `path_sum` operations.
- Path sums are maintained in amortized `O(log n)`.
- Nodes are identified by indices in the input array.

## Quick Start
```moonbit
///|
test "README link-cut tree usage" {
  let lct = LinkCutTree::new([1, 2, 3, 4])
  assert_eq(lct.link(0, 1), true)
  assert_eq(lct.link(1, 2), true)
  assert_eq(lct.link(1, 3), true)
  assert_eq(lct.path_sum(2, 3), Some(9))
  lct.set_value(2, 10)
  assert_eq(lct.path_sum(2, 3), Some(16))
  assert_eq(lct.cut(1, 3), true)
  assert_eq(lct.connected(2, 3), false)
}
```

## API Overview
- `LinkCutTree::new(values)` – create a forest from node values.
- `len()` – number of nodes in the structure.
- `link(u, v)` – connect two trees by an edge.
- `cut(u, v)` – remove an edge between `u` and `v`.
- `connected(u, v)` – check if two nodes are in the same tree.
- `set_value(index, value)` – update a node's value.
- `path_sum(u, v)` – sum of values on the path (returns `None` if disconnected).
