///|
test "cartesian_tree_structure" {
  let arr = [5, 2, 6, 3, 4]
  let tree = CartesianTree::from_array(arr.copy())
  assert_eq(tree.len(), arr.length())
  assert_eq(tree.is_empty(), false)
  assert_eq(tree.root_index(), Some(1))
  assert_eq(tree.value_at(1), Some(2))
  assert_eq(tree.left_child(1), Some(0))
  assert_eq(tree.right_child(1), Some(3))
  assert_eq(tree.left_child(3), Some(2))
  assert_eq(tree.right_child(3), Some(4))
  assert_eq(tree.parent_index(0), Some(1))
  assert_eq(tree.parent_index(2), Some(3))
  assert_eq(tree.parent_index(1), None)
  assert_eq(tree.inorder(), arr)
}

///|
test "cartesian_tree_heap_property_and_empty" {
  let arr = [5, 2, 6, 3, 4, 1]
  let tree = CartesianTree::from_array(arr.copy())
  assert_eq(tree.len(), arr.length())
  let root_idx = tree.root_index().unwrap()
  assert_eq(tree.value_at(root_idx), Some(1))
  for i in 0..<tree.len() {
    let parent_value = tree.value_at(i).unwrap()
    match tree.left_child(i) {
      Some(left_idx) => {
        let left_value = tree.value_at(left_idx).unwrap()
        assert_eq(parent_value <= left_value, true)
      }
      None => ()
    }
    match tree.right_child(i) {
      Some(right_idx) => {
        let right_value = tree.value_at(right_idx).unwrap()
        assert_eq(parent_value <= right_value, true)
      }
      None => ()
    }
  }
  let empty_arr = Array::make(0, 0)
  let empty_tree = CartesianTree::from_array(empty_arr)
  assert_eq(empty_tree.is_empty(), true)
  assert_eq(empty_tree.root_index(), None)
  assert_eq(empty_tree.inorder().length(), 0)
}

///|
test "cartesian_tree_handles_duplicates" {
  let arr = [4, 4, 4]
  let tree = CartesianTree::from_array(arr.copy())
  assert_eq(tree.root_index(), Some(0))
  assert_eq(tree.left_child(0), None)
  assert_eq(tree.right_child(0), Some(1))
  assert_eq(tree.right_child(1), Some(2))
  assert_eq(tree.parent_index(2), Some(1))
  assert_eq(tree.inorder(), arr)
}
