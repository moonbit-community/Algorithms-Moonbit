///|
test "treap basic operations" {
  let treap : Treap[Int, Int] = Treap::new()
  assert_eq(treap.is_empty(), true)
  treap.insert(10, 100)
  treap.insert(5, 50)
  treap.insert(20, 200)
  assert_eq(treap.len(), 3)
  assert_eq(treap.is_empty(), false)
  assert_eq(treap.get(10), Some(100))
  assert_eq(treap.get(5), Some(50))
  assert_eq(treap.get(20), Some(200))
  assert_eq(treap.contains(15), false)
}

///|
test "treap duplicate update preserves size" {
  let treap : Treap[Int, String] = Treap::new()
  treap.insert(1, "one")
  treap.insert(2, "two")
  treap.insert(3, "three")
  assert_eq(treap.len(), 3)
  treap.insert(2, "TWO")
  assert_eq(treap.len(), 3)
  assert_eq(treap.get(2), Some("TWO"))
}

///|
test "treap removal cases" {
  let treap : Treap[Int, Int] = Treap::new()
  let values = [7, 3, 10, 1, 5, 9, 12]
  for value in values {
    treap.insert(value, value * 2)
  }
  assert_eq(treap.len(), values.length())
  assert_eq(treap.remove(3), true)
  assert_eq(treap.contains(3), false)
  assert_eq(treap.remove(10), true)
  assert_eq(treap.contains(10), false)
  assert_eq(treap.remove(8), false)
  assert_eq(treap.len(), values.length() - 2)
  assert_eq(treap.get(9), Some(18))
  assert_eq(treap.get(12), Some(24))
}

///|
test "treap clear resets structure" {
  let treap : Treap[Int, Int] = Treap::default()
  for value in [1, 2, 3, 4, 5] {
    treap.insert(value, value)
  }
  assert_eq(treap.len(), 5)
  treap.clear()
  assert_eq(treap.len(), 0)
  assert_eq(treap.is_empty(), true)
  assert_eq(treap.get(3), None)
  assert_eq(treap.remove(3), false)
}

///|
test "treap handles larger sequence" {
  let treap : Treap[Int, Int] = Treap::new()
  for value in 0..<100 {
    treap.insert(value, value)
  }
  assert_eq(treap.len(), 100)
  for value in 0..<100 {
    assert_eq(treap.get(value), Some(value))
  }
  for value in 0..<50 {
    assert_eq(treap.remove(value), true)
  }
  assert_eq(treap.len(), 50)
  for value in 0..<50 {
    assert_eq(treap.contains(value), false)
  }
  for value in 50..<100 {
    assert_eq(treap.contains(value), true)
  }
}
