///|
test "chtholly tree build and point query" {
  let tree = ChthollyTree::from_array([1, 1, 2, 2, 3])
  assert_eq(tree.size(), 5)
  assert_eq(tree.len(), 3)
  assert_eq(tree.value_at(0).unwrap(), 1)
  assert_eq(tree.value_at(3).unwrap(), 2)
  assert_eq(tree.value_at(4).unwrap(), 3)
}

///|
test "chtholly tree add and range sum" {
  let tree = ChthollyTree::from_array([0, 1, 1, 1, 2, 2])
  tree.add(1, 4, 3).unwrap()
  assert_eq(tree.query_sum(0, 5).unwrap(), 17)
  assert_eq(tree.value_at(4).unwrap(), 5)
  tree.add(0, 5, -1).unwrap()
  assert_eq(tree.query_sum(0, 5).unwrap(), 12)
}
