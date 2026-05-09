///|
test "splay basic operations" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  @debug.assert_eq(tree.is_empty(), true)
  tree.insert(10, 100)
  tree.insert(20, 200)
  tree.insert(5, 50)
  @debug.assert_eq(tree.len(), 3)
  @debug.assert_eq(tree.is_empty(), false)
  @debug.assert_eq(tree.get(20), Some(200))
  @debug.assert_eq(tree.get(20), Some(200))
  @debug.assert_eq(tree.contains(5), true)
  @debug.assert_eq(tree.remove(5), true)
  @debug.assert_eq(tree.contains(5), false)
  @debug.assert_eq(tree.len(), 2)
}

///|
test "splay repeated access stays consistent" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(30, 300)
  tree.insert(40, 400)
  tree.insert(10, 100)
  tree.insert(50, 500)
  tree.insert(20, 200)
  @debug.assert_eq(tree.get(10), Some(100))
  @debug.assert_eq(tree.get(50), Some(500))
  @debug.assert_eq(tree.get(20), Some(200))
  @debug.assert_eq(tree.remove(10), true)
  @debug.assert_eq(tree.contains(10), false)
  @debug.assert_eq(tree.get(50), Some(500))
}

///|
test "splay removes and re-links subtrees" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(25, 1)
  tree.insert(15, 2)
  tree.insert(35, 3)
  tree.insert(30, 4)
  tree.insert(40, 5)
  @debug.assert_eq(tree.remove(35), true)
  @debug.assert_eq(tree.contains(35), false)
  @debug.assert_eq(tree.len(), 4)
  @debug.assert_eq(tree.get(30), Some(4))
  @debug.assert_eq(tree.get(40), Some(5))
  @debug.assert_eq(tree.get(15), Some(2))
}

///|
test "splay clear and replace value" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(1, 10)
  tree.insert(1, 20)
  @debug.assert_eq(tree.len(), 1)
  @debug.assert_eq(tree.get(1), Some(20))
  tree.clear()
  @debug.assert_eq(tree.len(), 0)
  @debug.assert_eq(tree.get(1), None)
  @debug.assert_eq(tree.is_empty(), true)
}
