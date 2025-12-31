///|
fn point_eq(a : Array[Double], b : Array[Double]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for idx in 0..<a.length() {
    if a[idx] != b[idx] {
      return false
    }
  }
  true
}

///|
fn contains_point(
  points : Array[Array[Double]],
  target : Array[Double],
) -> Bool {
  for point in points {
    if point_eq(point, target) {
      return true
    }
  }
  false
}

///|
test "kd-tree nearest neighbor" {
  let points = [
    [2.0, 3.0],
    [5.0, 4.0],
    [9.0, 6.0],
    [4.0, 7.0],
    [8.0, 1.0],
    [7.0, 2.0],
  ]
  let tree = KDTree::from_points(points)
  assert_eq(tree.len(), 6)
  let nearest = tree.nearest([9.0, 2.0])
  assert_eq(nearest, Some([8.0, 1.0]))
}

///|
test "kd-tree range search" {
  let points = [
    [2.0, 3.0],
    [5.0, 4.0],
    [9.0, 6.0],
    [4.0, 7.0],
    [8.0, 1.0],
    [7.0, 2.0],
  ]
  let tree = KDTree::from_points(points)
  let hits = tree.range_search([4.0, 2.0], [9.0, 6.0])
  assert_eq(hits.length(), 3)
  assert_eq(contains_point(hits, [5.0, 4.0]), true)
  assert_eq(contains_point(hits, [9.0, 6.0]), true)
  assert_eq(contains_point(hits, [7.0, 2.0]), true)
}

///|
test "kd-tree empty queries" {
  let tree = KDTree::from_points([])
  assert_eq(tree.is_empty(), true)
  assert_eq(tree.nearest([1.0, 2.0]), None)
  assert_eq(tree.range_search([0.0, 0.0], [1.0, 1.0]).length(), 0)
}
