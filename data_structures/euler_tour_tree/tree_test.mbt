///|
test "euler tour tree link, cut, and component size" {
  let ett = EulerTourTree::new(4)
  assert_eq(ett.component_size(0), 1)
  assert_eq(ett.link(0, 1), true)
  assert_eq(ett.link(1, 2), true)
  assert_eq(ett.link(1, 3), true)
  assert_eq(ett.connected(0, 2), true)
  assert_eq(ett.component_size(0), 4)
  assert_eq(ett.cut(1, 2), true)
  assert_eq(ett.connected(0, 2), false)
  assert_eq(ett.component_size(2), 1)
  assert_eq(ett.component_size(0), 3)
  assert_eq(ett.link(2, 3), true)
  assert_eq(ett.connected(2, 0), true)
  assert_eq(ett.component_size(0), 4)
}

///|
test "euler tour tree rejects redundant operations" {
  let ett = EulerTourTree::new(2)
  assert_eq(ett.link(0, 1), true)
  assert_eq(ett.link(0, 1), false)
  assert_eq(ett.cut(0, 1), true)
  assert_eq(ett.cut(0, 1), false)
}
