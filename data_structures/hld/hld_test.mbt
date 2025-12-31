///|
test "heavy_light_decomposition_lca_and_ranges" {
  let edges = [(0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6)]
  let hld = HeavyLightDecomposition::new(7, edges)
  inspect(hld.lca(3, 4), content="1")
  inspect(hld.lca(3, 6), content="0")
  let (left, right) = hld.subtree_range(1)
  inspect(right - left + 1, content="3")
}
