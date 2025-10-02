///|
test "splay basic operations" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  assert_eq(tree.is_empty(), true)
  tree.insert(10, 100)
  tree.insert(20, 200)
  tree.insert(5, 50)
  assert_eq(tree.len(), 3)
  assert_eq(tree.is_empty(), false)
  assert_eq(tree.get(20), Some(200))
  assert_eq(tree.get(20), Some(200))
  assert_eq(tree.contains(5), true)
  assert_eq(tree.remove(5), true)
  assert_eq(tree.contains(5), false)
  assert_eq(tree.len(), 2)
}

///|
test "splay repeated access stays consistent" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(30, 300)
  tree.insert(40, 400)
  tree.insert(10, 100)
  tree.insert(50, 500)
  tree.insert(20, 200)
  assert_eq(tree.get(10), Some(100))
  assert_eq(tree.get(50), Some(500))
  assert_eq(tree.get(20), Some(200))
  assert_eq(tree.remove(10), true)
  assert_eq(tree.contains(10), false)
  assert_eq(tree.get(50), Some(500))
}

///|
test "splay removes and re-links subtrees" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(25, 1)
  tree.insert(15, 2)
  tree.insert(35, 3)
  tree.insert(30, 4)
  tree.insert(40, 5)
  assert_eq(tree.remove(35), true)
  assert_eq(tree.contains(35), false)
  assert_eq(tree.len(), 4)
  assert_eq(tree.get(30), Some(4))
  assert_eq(tree.get(40), Some(5))
  assert_eq(tree.get(15), Some(2))
}

///|
test "splay clear and replace value" {
  let tree : SplayTree[Int, Int] = SplayTree::new()
  tree.insert(1, 10)
  tree.insert(1, 20)
  assert_eq(tree.len(), 1)
  assert_eq(tree.get(1), Some(20))
  tree.clear()
  assert_eq(tree.len(), 0)
  assert_eq(tree.get(1), None)
  assert_eq(tree.is_empty(), true)
}
