///|
test "red-black tree basic operations" {
  let tree : RedBlackTree[Int, Int] = RedBlackTree::new()
  assert_eq(tree.is_empty(), true)
  tree.insert(10, 100)
  tree.insert(5, 50)
  tree.insert(20, 200)
  assert_eq(tree.len(), 3)
  assert_eq(tree.is_empty(), false)
  assert_eq(tree.get(10), Some(100))
  assert_eq(tree.get(5), Some(50))
  assert_eq(tree.get(20), Some(200))
  assert_eq(tree.contains(15), false)
}

///|
test "red-black tree duplicate update preserves size" {
  let tree : RedBlackTree[Int, String] = RedBlackTree::new()
  tree.insert(1, "one")
  tree.insert(2, "two")
  tree.insert(3, "three")
  assert_eq(tree.len(), 3)
  tree.insert(2, "TWO")
  assert_eq(tree.len(), 3)
  assert_eq(tree.get(2), Some("TWO"))
}

///|
test "red-black tree removal cases" {
  let tree : RedBlackTree[Int, Int] = RedBlackTree::new()
  let values = [7, 3, 10, 1, 5, 9, 12]
  for value in values {
    tree.insert(value, value * 2)
  }
  assert_eq(tree.len(), values.length())
  assert_eq(tree.remove(3), true)
  assert_eq(tree.contains(3), false)
  assert_eq(tree.remove(10), true)
  assert_eq(tree.contains(10), false)
  assert_eq(tree.remove(8), false)
  assert_eq(tree.len(), values.length() - 2)
  assert_eq(tree.get(9), Some(18))
  assert_eq(tree.get(12), Some(24))
}

///|
test "red-black tree clear resets structure" {
  let tree : RedBlackTree[Int, Int] = RedBlackTree::default()
  for value in [1, 2, 3, 4, 5] {
    tree.insert(value, value)
  }
  assert_eq(tree.len(), 5)
  tree.clear()
  assert_eq(tree.len(), 0)
  assert_eq(tree.is_empty(), true)
  assert_eq(tree.get(3), None)
  assert_eq(tree.remove(3), false)
}

///|
test "red-black tree handles larger sequence" {
  let tree : RedBlackTree[Int, Int] = RedBlackTree::new()
  for value in 0..<100 {
    tree.insert(value, value)
  }
  assert_eq(tree.len(), 100)
  for value in 0..<100 {
    assert_eq(tree.get(value), Some(value))
  }
  for value in 0..<50 {
    assert_eq(tree.remove(value), true)
  }
  assert_eq(tree.len(), 50)
  for value in 0..<50 {
    assert_eq(tree.contains(value), false)
  }
  for value in 50..<100 {
    assert_eq(tree.contains(value), true)
  }
}
