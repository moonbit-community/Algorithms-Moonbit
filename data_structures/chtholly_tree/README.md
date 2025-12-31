# Chtholly Tree (珂朵莉树)

A Chtholly Tree (also known as ODT) maintains a set of disjoint, ordered
intervals with equal values. It performs range updates by splitting intervals
and works well for randomized or average-case workloads where the number of
splits stays small.

## Highlights
- Stores disjoint intervals covering a 0-based index range.
- Supports range assignment, range add, point query, and range sum.
- Automatically merges adjacent intervals with the same value.

## Quick Start
```moonbit
///|
test "README chtholly tree usage" {
  let tree = ChthollyTree::from_array([1, 1, 2, 2, 3])
  assert_eq(tree.len(), 3)
  assert_eq(tree.value_at(2).unwrap(), 2)

  tree.assign(1, 3, 5).unwrap()
  assert_eq(tree.query_sum(0, 4).unwrap(), 1 + 5 + 5 + 5 + 3)

  tree.add(0, 4, 1).unwrap()
  assert_eq(tree.value_at(4).unwrap(), 4)
}
```

## API Overview
- `ChthollyTree::new(length, value)` – create a tree covering `[0, length-1]`.
- `ChthollyTree::from_array(values)` – build from an array of values.
- `assign(left, right, value)` – overwrite a range.
- `add(left, right, delta)` – add `delta` to each value in a range.
- `query_sum(left, right)` – sum values in a range.
- `value_at(pos)` – point query.
- `len()` / `size()` / `is_empty()` – inspect interval count and range length.
