///|
test "persistent treap versions are immutable" {
  let t0 : PersistentTreap[Int, Int] = PersistentTreap::new()
  let t1 = t0.insert(10, 100)
  let t2 = t1.insert(5, 50)
  let t3 = t2.insert(20, 200)
  assert_eq(t0.len(), 0)
  assert_eq(t1.len(), 1)
  assert_eq(t2.len(), 2)
  assert_eq(t3.len(), 3)
  assert_eq(t0.get(10), None)
  assert_eq(t1.get(10), Some(100))
  assert_eq(t2.get(5), Some(50))
  assert_eq(t3.get(20), Some(200))
}

///|
test "persistent treap updates preserve size" {
  let t0 : PersistentTreap[Int, String] = PersistentTreap::new()
  let t1 = t0.insert(1, "one")
  let t2 = t1.insert(2, "two")
  let t3 = t2.insert(2, "TWO")
  assert_eq(t2.len(), 2)
  assert_eq(t3.len(), 2)
  assert_eq(t2.get(2), Some("two"))
  assert_eq(t3.get(2), Some("TWO"))
}

///|
test "persistent treap removal returns new version" {
  let t0 : PersistentTreap[Int, Int] = PersistentTreap::new()
  let mut current = t0
  for value in [7, 3, 10, 1, 5, 9, 12] {
    current = current.insert(value, value * 2)
  }
  let (t1, removed) = current.remove(3)
  assert_eq(removed, true)
  assert_eq(current.contains(3), true)
  assert_eq(t1.contains(3), false)
  let (t2, missing) = t1.remove(8)
  assert_eq(missing, false)
  assert_eq(t2.len(), t1.len())
}

///|
test "persistent treap clear keeps snapshots" {
  let t0 : PersistentTreap[Int, Int] = PersistentTreap::new()
  let t1 = t0.insert(1, 1).insert(2, 2).insert(3, 3)
  let t2 = t1.clear()
  assert_eq(t1.len(), 3)
  assert_eq(t2.len(), 0)
  assert_eq(t2.get(2), None)
  assert_eq(t1.get(2), Some(2))
}

///|
test "persistent treap handles larger sequence" {
  let mut treap : PersistentTreap[Int, Int] = PersistentTreap::new()
  for value in 0..<100 {
    treap = treap.insert(value, value)
  }
  assert_eq(treap.len(), 100)
  for value in 0..<100 {
    assert_eq(treap.get(value), Some(value))
  }
  let mut updated = treap
  for value in 0..<50 {
    let (next, removed) = updated.remove(value)
    assert_eq(removed, true)
    updated = next
  }
  assert_eq(updated.len(), 50)
  for value in 0..<50 {
    assert_eq(updated.contains(value), false)
  }
  for value in 50..<100 {
    assert_eq(updated.contains(value), true)
  }
}
