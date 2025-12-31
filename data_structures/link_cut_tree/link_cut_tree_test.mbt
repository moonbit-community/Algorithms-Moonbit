///|
test "link-cut tree basic connectivity and path sum" {
  let lct = LinkCutTree::new([1, 2, 3, 4])
  assert_eq(lct.connected(0, 1), false)
  assert_eq(lct.link(0, 1), true)
  assert_eq(lct.link(1, 2), true)
  assert_eq(lct.link(1, 3), true)
  assert_eq(lct.connected(0, 3), true)
  assert_eq(lct.path_sum(2, 3), Some(9))
  lct.set_value(2, 10)
  assert_eq(lct.path_sum(2, 3), Some(16))
}

///|
test "link-cut tree cut and relink" {
  let lct = LinkCutTree::new([5, 6, 7])
  assert_eq(lct.link(0, 1), true)
  assert_eq(lct.link(1, 2), true)
  assert_eq(lct.path_sum(0, 2), Some(18))
  assert_eq(lct.cut(1, 2), true)
  assert_eq(lct.connected(0, 2), false)
  assert_eq(lct.path_sum(0, 2), None)
  assert_eq(lct.link(0, 2), true)
  assert_eq(lct.path_sum(1, 2), Some(18))
}

///|
test "link-cut tree rejects redundant operations" {
  let lct = LinkCutTree::new([2, 4])
  assert_eq(lct.link(0, 1), true)
  assert_eq(lct.link(0, 1), false)
  assert_eq(lct.cut(0, 1), true)
  assert_eq(lct.cut(0, 1), false)
}
