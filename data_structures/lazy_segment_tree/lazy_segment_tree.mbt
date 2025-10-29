///|
pub enum LazySegmentTreeError {
  IndexOutOfBounds
  InvalidRange
} derive(Show, Eq)

///|
pub struct LazySegmentTree[T, L] {
  size : Int
  tree : Array[T]
  tag : Array[L]
  merge : (T, T) -> T
  apply : (T, L, Int) -> T
  compose : (L, L) -> L
  identity : L
} derive(Show)

///|
fn[T, L] build(
  self : LazySegmentTree[T, L],
  arr : Array[T],
  node : Int,
  start : Int,
  end : Int,
) -> Unit {
  if start == end {
    self.tree[node] = arr[start]
    return
  }
  let mid = (start + end) / 2
  let left = node * 2
  let right = left + 1
  self.build(arr, left, start, mid)
  self.build(arr, right, mid + 1, end)
  self.tree[node] = (self.merge)(self.tree[left], self.tree[right])
}

///|
fn[T, L] push(
  self : LazySegmentTree[T, L],
  node : Int,
  start : Int,
  end : Int,
) -> Unit {
  if start == end {
    self.tag[node] = self.identity
    return
  }
  let tag = self.tag[node]
  let mid = (start + end) / 2
  let left = node * 2
  let right = left + 1
  let left_len = mid - start + 1
  let right_len = end - mid
  self.tree[left] = (self.apply)(self.tree[left], tag, left_len)
  self.tree[right] = (self.apply)(self.tree[right], tag, right_len)
  self.tag[left] = (self.compose)(self.tag[left], tag)
  self.tag[right] = (self.compose)(self.tag[right], tag)
  self.tag[node] = self.identity
}

///|
fn[T, L] range_update_internal(
  self : LazySegmentTree[T, L],
  node : Int,
  start : Int,
  end : Int,
  left : Int,
  right : Int,
  value : L,
) -> Unit {
  if left > end || right < start {
    return
  }
  if left <= start && end <= right {
    let length = end - start + 1
    self.tree[node] = (self.apply)(self.tree[node], value, length)
    self.tag[node] = (self.compose)(self.tag[node], value)
    return
  }
  self.push(node, start, end)
  let mid = (start + end) / 2
  let left_node = node * 2
  let right_node = left_node + 1
  self.range_update_internal(left_node, start, mid, left, right, value)
  self.range_update_internal(right_node, mid + 1, end, left, right, value)
  self.tree[node] = (self.merge)(self.tree[left_node], self.tree[right_node])
}

///|
fn[T, L] range_query_internal(
  self : LazySegmentTree[T, L],
  node : Int,
  start : Int,
  end : Int,
  left : Int,
  right : Int,
) -> T? {
  if left > end || right < start {
    return None
  }
  if left <= start && end <= right {
    return Some(self.tree[node])
  }
  self.push(node, start, end)
  let mid = (start + end) / 2
  let left_node = node * 2
  let right_node = left_node + 1
  let left_res = self.range_query_internal(left_node, start, mid, left, right)
  let right_res = self.range_query_internal(
    right_node,
    mid + 1,
    end,
    left,
    right,
  )
  match (left_res, right_res) {
    (None, None) => None
    (Some(value), None) => Some(value)
    (None, Some(value)) => Some(value)
    (Some(a), Some(b)) => Some((self.merge)(a, b))
  }
}

///|
///Creates a new `LazySegmentTree` from the provided slice of elements.
///
/// # Parameters
///
/// - `arr` : A slice of elements of type `T` to initialize the segment tree.(0-based)
/// - `merge` : Function to merge two nodes of the segment tree.
/// - `apply` : Function that applies a lazy value `L` to a node value `T` over a segment length.
/// - `compose` : Function describing how to compose two lazy values.
/// - `identity` : Identity lazy value representing "do nothing".
///
/// # Returns
///
/// - `LazySegmentTree` : A new `LazySegmentTree` instance populated with the given elements.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5]
///   let _ = LazySegmentTree::from_array(
///     a1,
///     fn(a, b) { a + b },
///     fn(value, tag, length) { value + tag * length },
///     fn(old, new) { old + new },
///     0,
///   )
/// ```
pub fn[T : Default, L] LazySegmentTree::from_array(
  arr : Array[T],
  merge : (T, T) -> T,
  apply : (T, L, Int) -> T,
  compose : (L, L) -> L,
  identity : L,
) -> LazySegmentTree[T, L] {
  let size = arr.length()
  let capacity = if size == 0 { 1 } else { 4 * size }
  let tree = Array::make(capacity, T::default())
  let tag = Array::make(capacity, identity)
  let seg = LazySegmentTree::{
    size,
    tree,
    tag,
    merge,
    apply,
    compose,
    identity,
  }
  if size > 0 {
    seg.build(arr, 1, 0, size - 1)
  }
  seg
}

///|
///Performs a range update on the segment tree using the provided lazy value.
///
/// # Parameters
///
/// - `self` : `LazySegmentTree`
/// - `left` : The left boundary of the range (inclusive).
/// - `right` : The right boundary of the range (inclusive).
/// - `value` : The lazy value to apply over the range.
///
/// # Returns
///
/// - `Ok(())` if the update was successful.
/// - `Err(LazySegmentTreeError::InvalidRange)` if the range is invalid or the tree is empty.
/// - `Err(LazySegmentTreeError::IndexOutOfBounds)` if the range is outside the array or the tree is empty.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5]
///   let seg = LazySegmentTree::from_array(
///     a1,
///     fn(a, b) { a + b },
///     fn(value, tag, length) { value + tag * length },
///     fn(old, new) { old + new },
///     0,
///   )
///   inspect(seg.range_update(0, 2, 5).unwrap(), content="()")
/// ```
pub fn[T, L] LazySegmentTree::range_update(
  self : LazySegmentTree[T, L],
  left : Int,
  right : Int,
  value : L,
) -> Result[Unit, LazySegmentTreeError] {
  if left < 0 || right < 0 {
    return Err(LazySegmentTreeError::IndexOutOfBounds)
  }
  if self.size == 0 {
    return Err(LazySegmentTreeError::InvalidRange)
  }
  if left >= self.size || right >= self.size {
    return Err(LazySegmentTreeError::IndexOutOfBounds)
  }
  if left > right {
    return Err(LazySegmentTreeError::InvalidRange)
  }
  self.range_update_internal(1, 0, self.size - 1, left, right, value)
  Ok(())
}

///|
///Queries the segment tree for the merged value within the given range.
///
/// # Parameters
///
/// - `self` : `LazySegmentTree`
/// - `left` : The left boundary of the range (inclusive).
/// - `right` : The right boundary of the range (inclusive).
///
/// # Returns
///
/// - `Ok(Some(result))` if the query was successful and the range is non-empty.
/// - `Ok(None)` if `left > right`.
/// - `Err(LazySegmentTreeError::IndexOutOfBounds)` if the range is outside the array or the tree is empty.
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5]
///   let seg = LazySegmentTree::from_array(
///     a1,
///     fn(a, b) { a + b },
///     fn(value, tag, length) { value + tag * length },
///     fn(old, new) { old + new },
///     0,
///   )
///   inspect(seg.range_query(1, 3).unwrap(), content="Some(9)")
/// ```
pub fn[T, L] LazySegmentTree::range_query(
  self : LazySegmentTree[T, L],
  left : Int,
  right : Int,
) -> Result[T?, LazySegmentTreeError] {
  if left < 0 || right < 0 {
    return Err(LazySegmentTreeError::IndexOutOfBounds)
  }
  if self.size == 0 {
    return Err(LazySegmentTreeError::IndexOutOfBounds)
  }
  if left >= self.size || right >= self.size {
    return Err(LazySegmentTreeError::IndexOutOfBounds)
  }
  if left > right {
    return Ok(None)
  }
  let result = self.range_query_internal(1, 0, self.size - 1, left, right)
  Ok(result)
}
