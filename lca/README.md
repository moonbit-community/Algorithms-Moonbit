# LCA (Lowest Common Ancestor) Algorithm

## Functions

### create_Lca

Creates an LCA (Lowest Common Ancestor) instance.

#### Parameters

- `data` : Array of tuples representing the edges of the tree.
- `root~` : Root of the tree (default is 1).

#### Returns

- `LCA` : An instance of the LCA structure.

#### Example

```moonbit
test {
  let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
  let lca = create_Lca(data, root = 1)
  inspect!(lca.root, content="1")
}
```

### lca

Finds the Lowest Common Ancestor (LCA) of two nodes.

#### Parameters

- `self` : An instance of the LCA structure.
- `u` : First node.
- `v` : Second node.

#### Returns

- `Int` : The lowest common ancestor of nodes `u` and `v`.

#### Example

```moonbit
test {
  let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
  let lca = create_Lca(data, root = 1)
  inspect!(lca.lca(4, 5), content="2")
  inspect!(lca.lca(4, 3), content="1")
}
```
