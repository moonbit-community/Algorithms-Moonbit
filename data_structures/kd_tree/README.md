# KD Tree

A balanced k-dimensional tree for organizing multi-dimensional points. This
implementation builds the tree by median splitting along alternating axes and
supports nearest-neighbor and axis-aligned range queries.

## Highlights
- Builds a balanced KD-tree from `Array[Array[Double]]` points.
- Fast nearest-neighbor queries with axis-based pruning.
- Range search for axis-aligned bounding boxes.

## Quick Start
```moonbit
///|
test "README kd-tree usage" {
  let points = [
    [2.0, 3.0],
    [5.0, 4.0],
    [9.0, 6.0],
    [4.0, 7.0],
    [8.0, 1.0],
    [7.0, 2.0],
  ]
  let tree = KDTree::from_points(points)
  let nearest = tree.nearest([9.0, 2.0]).unwrap()
  assert_eq(nearest, [8.0, 1.0])

  let hits = tree.range_search([4.0, 2.0], [9.0, 6.0])
  assert_eq(hits.length(), 3)
}
```

## API Overview
- `KDTree::new(dimension)` – create an empty tree with a fixed dimension.
- `KDTree::from_points(points)` – build a balanced tree from points.
- `len()` / `is_empty()` – inspect size.
- `nearest(target)` – nearest-neighbor query.
- `range_search(lower, upper)` – axis-aligned range search.
