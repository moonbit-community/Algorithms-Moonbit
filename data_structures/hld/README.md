# Heavy-Light Decomposition

Heavy-Light Decomposition (树链剖分) splits a tree into heavy paths so that any
path query can be answered using a small number of contiguous segments on a
flattened array.

## Highlights
- `lca` for lowest common ancestor.
- `path_segments` to turn a path into array ranges for segment trees or BITs.
- `subtree_range` to turn subtree queries into one contiguous range.

## Quick Start
```moonbit
///|
test "README heavy-light decomposition" {
  let edges = [(0, 1), (1, 2), (1, 3), (3, 4)]
  let values = [2, 1, 5, 3, 4]
  let hld = HeavyLightDecomposition::new(5, edges)
  let base = hld.reorder(values)
  let seg = SegmentTree::from_array(base, fn(a, b) { a + b })

  let mut total = 0
  for (l, r) in hld.path_segments(2, 4) {
    match seg.query(l, r).unwrap() {
      Some(value) => total += value
      None => ()
    }
  }
  inspect(total, content="13")
}
```

## API Overview
- `HeavyLightDecomposition::new(n, edges, root?)` – build the decomposition.
- `len()` – number of nodes.
- `lca(u, v)` – lowest common ancestor.
- `path_segments(u, v)` – flattened ranges covering the path.
- `subtree_range(u)` – flattened range covering the subtree.
- `position(u)` / `node_at(pos)` – map between nodes and flattened positions.
