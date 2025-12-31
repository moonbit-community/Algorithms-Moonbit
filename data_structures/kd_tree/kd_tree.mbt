///|
/// A KD-tree (k-dimensional tree) for organizing multi-dimensional points.
///
/// This implementation builds a balanced tree by median splitting along
/// alternating axes, and supports nearest-neighbor and axis-aligned range
/// queries.
///
/// Points are represented as `Array[Double]` with a fixed dimension.
///

///|
pub struct KDTree {
  dimension : Int
  size : Int
  root : Node?
}

///|
struct Node {
  point : Array[Double]
  axis : Int
  left : Node?
  right : Node?
}

///|
/// Creates an empty KD-tree with a fixed dimension.
///
/// # Parameters
/// - `dimension`: The number of coordinates per point. Must be positive.
///
/// # Returns
/// An empty `KDTree`.
///
/// # Panics
/// Panics if `dimension <= 0`.
///
pub fn KDTree::new(dimension : Int) -> KDTree {
  if dimension <= 0 {
    abort("KDTree dimension must be positive")
  }
  KDTree::{ dimension, size: 0, root: None }
}

///|
/// Builds a KD-tree from a list of points.
///
/// The tree is built by recursively sorting points along alternating axes and
/// choosing the median as the splitting plane.
///
/// # Parameters
/// - `points`: Array of points, each point must have the same dimension.
///
/// # Returns
/// A `KDTree` containing the points.
///
/// # Panics
/// Panics if any point has a different dimension.
///
pub fn KDTree::from_points(points : Array[Array[Double]]) -> KDTree {
  if points.length() == 0 {
    return KDTree::{ dimension: 0, size: 0, root: None }
  }
  let dimension = points[0].length()
  if dimension == 0 {
    abort("KDTree dimension must be positive")
  }
  for point in points {
    ensure_dimension(point, dimension)
  }
  let root = build(points, 0, dimension)
  KDTree::{ dimension, size: points.length(), root }
}

///|
/// Returns the number of stored points.
///
pub fn KDTree::len(self : KDTree) -> Int {
  self.size
}

///|
/// Returns `true` if the tree contains no points.
///
pub fn KDTree::is_empty(self : KDTree) -> Bool {
  self.size == 0
}

///|
/// Finds the nearest point to the target, if any points exist.
///
/// # Parameters
/// - `target`: The query point.
///
/// # Returns
/// The nearest point or `None` if the tree is empty.
///
/// # Panics
/// Panics if the target dimension does not match the tree dimension.
///
pub fn KDTree::nearest(self : KDTree, target : Array[Double]) -> Array[Double]? {
  if self.is_empty() {
    return None
  }
  ensure_dimension(target, self.dimension)
  let (best, _) = nearest_node(self.root, target, None, 1.0e308)
  best
}

///|
/// Performs an axis-aligned range query.
///
/// # Parameters
/// - `lower`: Inclusive lower bounds for each dimension.
/// - `upper`: Inclusive upper bounds for each dimension.
///
/// # Returns
/// An array of points inside the query box.
///
/// # Panics
/// Panics if the bounds do not match the tree dimension.
///
pub fn KDTree::range_search(
  self : KDTree,
  lower : Array[Double],
  upper : Array[Double],
) -> Array[Array[Double]] {
  if self.is_empty() {
    return []
  }
  ensure_dimension(lower, self.dimension)
  ensure_dimension(upper, self.dimension)
  let results : Array[Array[Double]] = []
  range_collect(self.root, lower, upper, results)
  results
}

///|
fn ensure_dimension(point : Array[Double], dimension : Int) -> Unit {
  if point.length() != dimension {
    abort("Point dimension mismatch")
  }
}

///|
fn build(points : Array[Array[Double]], depth : Int, dimension : Int) -> Node? {
  if points.length() == 0 {
    return None
  }
  let axis = depth % dimension
  let sorted = sort_by_axis(points, axis)
  let median = sorted.length() / 2
  let point = sorted[median]
  let left = build(sorted[:median].to_array(), depth + 1, dimension)
  let right = build(sorted[median + 1:].to_array(), depth + 1, dimension)
  Some(Node::{ point, axis, left, right })
}

///|
fn sort_by_axis(
  points : Array[Array[Double]],
  axis : Int,
) -> Array[Array[Double]] {
  if points.length() <= 1 {
    return points
  }
  let mid = points.length() / 2
  let left = sort_by_axis(points[:mid].to_array(), axis)
  let right = sort_by_axis(points[mid:].to_array(), axis)
  merge_by_axis(left, right, axis)
}

///|
fn merge_by_axis(
  left : Array[Array[Double]],
  right : Array[Array[Double]],
  axis : Int,
) -> Array[Array[Double]] {
  let merged : Array[Array[Double]] = []
  let mut i = 0
  let mut j = 0
  while i < left.length() || j < right.length() {
    if j == right.length() {
      merged.push(left[i])
      i += 1
    } else if i == left.length() {
      merged.push(right[j])
      j += 1
    } else if left[i][axis] <= right[j][axis] {
      merged.push(left[i])
      i += 1
    } else {
      merged.push(right[j])
      j += 1
    }
  }
  merged
}

///|
fn distance_sq(a : Array[Double], b : Array[Double]) -> Double {
  let mut sum = 0.0
  for idx in 0..<a.length() {
    let diff = a[idx] - b[idx]
    sum += diff * diff
  }
  sum
}

///|
fn nearest_node(
  node : Node?,
  target : Array[Double],
  best : Array[Double]?,
  best_dist : Double,
) -> (Array[Double]?, Double) {
  match node {
    None => (best, best_dist)
    Some(current) => {
      let mut best_point = best
      let mut best_distance = best_dist
      let current_distance = distance_sq(current.point, target)
      if current_distance < best_distance {
        best_distance = current_distance
        best_point = Some(current.point)
      }
      let axis = current.axis
      let diff = target[axis] - current.point[axis]
      let (near, far) = if diff <= 0.0 {
        (current.left, current.right)
      } else {
        (current.right, current.left)
      }
      let (best_after_near, best_dist_near) = nearest_node(
        near, target, best_point, best_distance,
      )
      let mut best_after_near_mut = best_after_near
      let mut best_dist_near_mut = best_dist_near
      if diff * diff < best_dist_near_mut {
        let (best_after_far, best_dist_far) = nearest_node(
          far, target, best_after_near_mut, best_dist_near_mut,
        )
        best_after_near_mut = best_after_far
        best_dist_near_mut = best_dist_far
      }
      (best_after_near_mut, best_dist_near_mut)
    }
  }
}

///|
fn range_collect(
  node : Node?,
  lower : Array[Double],
  upper : Array[Double],
  results : Array[Array[Double]],
) -> Unit {
  match node {
    None => ()
    Some(current) => {
      let mut in_range = true
      for idx in 0..<lower.length() {
        if current.point[idx] < lower[idx] || current.point[idx] > upper[idx] {
          in_range = false
          break
        }
      }
      if in_range {
        results.push(current.point)
      }
      let axis = current.axis
      if lower[axis] <= current.point[axis] {
        range_collect(current.left, lower, upper, results)
      }
      if upper[axis] >= current.point[axis] {
        range_collect(current.right, lower, upper, results)
      }
    }
  }
}
