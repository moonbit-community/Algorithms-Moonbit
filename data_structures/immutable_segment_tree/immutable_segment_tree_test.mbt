///|
test "persistent_segment_tree_sum_versions" {
  let arr = [1, 2, 3, 4, 5]
  let seg0 = PersistentSegmentTree::from_array(arr, fn(a, b) { a + b })
  inspect(seg0.query(0, 4).unwrap(), content="Some(15)")
  let seg1 = seg0.update(1, 10).unwrap()
  inspect(seg0.query(0, 4).unwrap(), content="Some(15)")
  inspect(seg1.query(0, 4).unwrap(), content="Some(23)")
  let seg2 = seg1.update(2, -3).unwrap()
  inspect(seg1.query(1, 2).unwrap(), content="Some(13)")
  inspect(seg2.query(1, 2).unwrap(), content="Some(7)")
}

///|
test "persistent_segment_tree_min_max_and_errors" {
  let arr = [8, -2, 7, 5, 4, -1]
  let min_tree = PersistentSegmentTree::from_array(arr, @cmp.minimum)
  let max_tree = PersistentSegmentTree::from_array(arr, @cmp.maximum)
  inspect(min_tree.query(0, 5).unwrap(), content="Some(-2)")
  inspect(max_tree.query(2, 4).unwrap(), content="Some(7)")
  let min_tree2 = min_tree.update(3, -10).unwrap()
  inspect(min_tree.query(0, 5).unwrap(), content="Some(-2)")
  inspect(min_tree2.query(0, 5).unwrap(), content="Some(-10)")
  inspect(min_tree.update(6, 1), content="Err(IndexOutOfBounds)")
  inspect(min_tree.query(4, 2), content="Err(InvalidRange)")
}
