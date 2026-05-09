///|
test "scapegoat tree basic operations" {
  let tree : ScapegoatTree[Int, String] = ScapegoatTree::new()
  @debug.assert_eq(tree.is_empty(), true)
  tree.insert(10, "ten")
  tree.insert(20, "twenty")
  tree.insert(5, "five")
  @debug.assert_eq(tree.len(), 3)
  @debug.assert_eq(tree.contains(20), true)
  @debug.assert_eq(tree.get(5), Some("five"))
  tree.insert(5, "FIVE")
  @debug.assert_eq(tree.get(5), Some("FIVE"))
  @debug.assert_eq(tree.remove(20), true)
  @debug.assert_eq(tree.contains(20), false)
  @debug.assert_eq(tree.len(), 2)
}

///|
test "scapegoat tree stays searchable after ordered inserts" {
  let tree : ScapegoatTree[Int, Int] = ScapegoatTree::new()
  for i in 1..<=15 {
    tree.insert(i, i * 10)
  }
  @debug.assert_eq(tree.len(), 15)
  @debug.assert_eq(tree.get(1), Some(10))
  @debug.assert_eq(tree.get(8), Some(80))
  @debug.assert_eq(tree.get(15), Some(150))
}

///|
test "scapegoat tree rebuilds after removals" {
  let tree : ScapegoatTree[Int, Int] = ScapegoatTree::new()
  for i in 1..<=12 {
    tree.insert(i, i)
  }
  for i in 1..<=8 {
    @debug.assert_eq(tree.remove(i), true)
  }
  @debug.assert_eq(tree.len(), 4)
  @debug.assert_eq(tree.contains(3), false)
  @debug.assert_eq(tree.contains(9), true)
  @debug.assert_eq(tree.get(12), Some(12))
}
