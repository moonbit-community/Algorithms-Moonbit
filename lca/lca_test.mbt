///|
test {
  let lca = create_Lca([(1, 2), (1, 3), (2, 4), (2, 5)])
  inspect(lca.lca(2, 3), content="1")
  let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
  let lca = create_Lca(data, root=1)
  inspect(lca.lca(4, 5), content="2")
  inspect(lca.lca(4, 3), content="1")
}
