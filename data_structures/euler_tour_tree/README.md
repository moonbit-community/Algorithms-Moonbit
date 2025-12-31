# Euler Tour Tree

An Euler Tour Tree maintains a dynamic forest by keeping an Euler tour inside a
randomized treap. It supports linking two trees, cutting an edge, and checking
connectivity while tracking the size of each connected component.

## Highlights
- `link`, `cut`, `connected`, and `component_size` operations.
- Each operation runs in amortized `O(log n)` with randomized treap balancing.
- Vertices are identified by their index (0-based).

## Quick Start
```moonbit
///|
test "README Euler Tour Tree usage" {
  let ett = EulerTourTree::new(4)
  assert_eq(ett.link(0, 1), true)
  assert_eq(ett.link(1, 2), true)
  assert_eq(ett.link(1, 3), true)
  assert_eq(ett.connected(0, 2), true)
  assert_eq(ett.component_size(0), 4)
  assert_eq(ett.cut(1, 2), true)
  assert_eq(ett.connected(0, 2), false)
  assert_eq(ett.component_size(2), 1)
}
```

## API Overview
- `EulerTourTree::new(size)` – create a forest with `size` isolated vertices.
- `len()` – number of vertices in the structure.
- `link(u, v)` – connect two different trees.
- `cut(u, v)` – remove an edge if present.
- `connected(u, v)` – check if two vertices are in the same tree.
- `component_size(v)` – number of vertices in `v`'s component.
