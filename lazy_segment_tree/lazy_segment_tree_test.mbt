///|
fn apply_sum(value : Int, tag : Int, length : Int) -> Int {
  value + tag * length
}

///|
fn compose_sum(old : Int, new_val : Int) -> Int {
  old + new_val
}

///|
test "lazy_segment_tree_range_add_sum" {
  let arr = [1, 2, 3, 4, 5, 6]
  let seg = LazySegmentTree::from_array(
    arr,
    fn(a, b) { a + b },
    apply_sum,
    compose_sum,
    0,
  )
  inspect(seg.range_query(0, 5).unwrap(), content="Some(21)")
  inspect(seg.range_update(1, 3, 2).unwrap(), content="()")
  inspect(seg.range_query(0, 2).unwrap(), content="Some(10)")
  inspect(seg.range_query(3, 5).unwrap(), content="Some(17)")
  inspect(seg.range_update(0, 5, -1).unwrap(), content="()")
  inspect(seg.range_query(0, 5).unwrap(), content="Some(21)")
}

///|
test "lazy_segment_tree_invalid_operations" {
  let arr = [1, 2, 3]
  let seg = LazySegmentTree::from_array(
    arr,
    fn(a, b) { a + b },
    apply_sum,
    compose_sum,
    0,
  )
  inspect(seg.range_query(-1, 2), content="Err(IndexOutOfBounds)")
  inspect(seg.range_query(0, 5), content="Err(IndexOutOfBounds)")
  inspect(seg.range_update(2, 1, 3), content="Err(InvalidRange)")
  inspect(seg.range_update(0, 4, 1), content="Err(IndexOutOfBounds)")
  inspect(seg.range_query(2, 1).unwrap(), content="None")
}
