test "floyd" {
  let eg = [(1, 2, 1), (2, 3, 20), (1, 4, 1), (4, 5, 1), (5, 3, 1)]
  let floyd = @apsp.create_floyd(eg, 5)
  inspect(floyd.query(1, 3), content="3")
}
