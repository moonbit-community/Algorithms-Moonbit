///|
struct Node[T] {
  value : T
  left : Node[T]?
  right : Node[T]?
} derive(Show)

///|
pub enum PersistentSegmentTreeError {
  IndexOutOfBounds
  InvalidRange
} derive(Show, Eq)

///|
pub struct PersistentSegmentTree[T] {
  size : Int
  root : Node[T]?
  merge : (T, T) -> T
} derive(Show)

///|
fn[T] PersistentSegmentTree::build(
  arr : Array[T],
  left : Int,
  right : Int,
  merge : (T, T) -> T,
) -> Node[T] {
  if left == right {
    return Node::{ value: arr[left], left: None, right: None }
  }
  let mid = (left + right) / 2
  let left_node = PersistentSegmentTree::build(arr, left, mid, merge)
  let right_node = PersistentSegmentTree::build(arr, mid + 1, right, merge)
  let value = merge(left_node.value, right_node.value)
  Node::{ value, left: Some(left_node), right: Some(right_node) }
}

///|
fn[T] PersistentSegmentTree::query_internal(
  node_opt : Node[T]?,
  start : Int,
  end : Int,
  left : Int,
  right : Int,
  merge : (T, T) -> T,
) -> T? {
  if left > end || right < start {
    return None
  }
  match node_opt {
    None => None
    Some(node) => {
      if left <= start && end <= right {
        return Some(node.value)
      }
      let mid = (start + end) / 2
      let left_res = PersistentSegmentTree::query_internal(
        node.left,
        start,
        mid,
        left,
        right,
        merge,
      )
      let right_res = PersistentSegmentTree::query_internal(
        node.right,
        mid + 1,
        end,
        left,
        right,
        merge,
      )
      match (left_res, right_res) {
        (None, None) => None
        (Some(value), None) => Some(value)
        (None, Some(value)) => Some(value)
        (Some(left_value), Some(right_value)) =>
          Some(merge(left_value, right_value))
      }
    }
  }
}

///|
fn[T] PersistentSegmentTree::update_internal(
  node_opt : Node[T]?,
  start : Int,
  end : Int,
  idx : Int,
  value : T,
  merge : (T, T) -> T,
) -> Node[T]? {
  if start == end {
    return Some(Node::{ value, left: None, right: None })
  }
  match node_opt {
    None => None
    Some(node) => {
      let mid = (start + end) / 2
      if idx <= mid {
        let new_left = PersistentSegmentTree::update_internal(
          node.left,
          start,
          mid,
          idx,
          value,
          merge,
        )
        let left_value = match new_left {
          None => return Some(node)
          Some(left_node) => left_node.value
        }
        let right_value = match node.right {
          None => return Some(node)
          Some(right_node) => right_node.value
        }
        let merged = merge(left_value, right_value)
        return Some(Node::{ value: merged, left: new_left, right: node.right })
      }
      let new_right = PersistentSegmentTree::update_internal(
        node.right,
        mid + 1,
        end,
        idx,
        value,
        merge,
      )
      let left_value = match node.left {
        None => return Some(node)
        Some(left_node) => left_node.value
      }
      let right_value = match new_right {
        None => return Some(node)
        Some(right_node) => right_node.value
      }
      let merged = merge(left_value, right_value)
      Some(Node::{ value: merged, left: node.left, right: new_right })
    }
  }
}

///|
///Creates a new `PersistentSegmentTree` from the provided slice of elements.
///
/// # Parameters
///
/// - `arr` : A slice of elements of type `T` to initialize the segment tree.(0-based)
/// - `merge` : A merging function that defines how to merge two elements of type `T`.
///
/// # Returns
///
/// - `PersistentSegmentTree` : A new `PersistentSegmentTree` instance populated with the given elements.
///
/// # Example
/// ```
///   let arr = [1, 2, 3, 4, 5]
///   let _ = PersistentSegmentTree::from_array(arr, fn(a, b) { a + b })
/// ```
pub fn[T] PersistentSegmentTree::from_array(
  arr : Array[T],
  merge : (T, T) -> T,
) -> PersistentSegmentTree[T] {
  let size = arr.length()
  if size == 0 {
    return PersistentSegmentTree::{ size, root: None, merge }
  }
  let root = PersistentSegmentTree::build(arr, 0, size - 1, merge)
  PersistentSegmentTree::{ size, root: Some(root), merge }
}

///|
///Queries the persistent segment tree for the result of merging the elements in the given range.
///
/// # Parameters
///
/// - `self` PersistentSegmentTree
/// - `left` : left point of the query range
/// - `right` : right point of the query range
///
/// # Returns
///
/// - `Ok(Some(result))` if the query was successful and there are elements in the range,
/// - `Ok(None)` if the range is empty,
/// - `Err(PersistentSegmentTreeError::InvalidRange)` if the provided range is invalid.
///
/// # Example
/// ```
///   let arr = [1, 2, 3, 4, 5]
///   let seg = PersistentSegmentTree::from_array(arr, fn(a, b) { a + b })
///   inspect(seg.query(1, 3).unwrap(), content = "Some(9)")
/// ```
pub fn[T] PersistentSegmentTree::query(
  self : PersistentSegmentTree[T],
  left : Int,
  right : Int,
) -> Result[T?, PersistentSegmentTreeError] {
  if left < 0 ||
    right < 0 ||
    left > right ||
    left >= self.size ||
    right >= self.size {
    return Err(PersistentSegmentTreeError::InvalidRange)
  }
  let res = PersistentSegmentTree::query_internal(
    self.root,
    0,
    self.size - 1,
    left,
    right,
    self.merge,
  )
  Ok(res)
}

///|
///Creates a new version of the segment tree with the value updated at the specified index.
///
/// # Parameters
///
/// - `self` PersistentSegmentTree
/// - `idx` : The index (0-based) of the element to update.
/// - `val` : The new value of type `T` to set at the specified index.
///
/// # Returns
///
/// - `Ok(PersistentSegmentTree)` if the update was successful,
/// - `Err(PersistentSegmentTreeError::IndexOutOfBounds)` if the index is out of bounds.
///
/// # Example
/// ```
///   let arr = [1, 2, 3, 4, 5]
///   let seg = PersistentSegmentTree::from_array(arr, fn(a, b) { a + b })
///   let seg2 = seg.update(2, 10).unwrap()
///   inspect(seg2.query(0, 4).unwrap(), content = "Some(22)")
/// ```
pub fn[T] PersistentSegmentTree::update(
  self : PersistentSegmentTree[T],
  idx : Int,
  val : T,
) -> Result[PersistentSegmentTree[T], PersistentSegmentTreeError] {
  if idx < 0 || idx >= self.size {
    return Err(PersistentSegmentTreeError::IndexOutOfBounds)
  }
  let root = PersistentSegmentTree::update_internal(
    self.root,
    0,
    self.size - 1,
    idx,
    val,
    self.merge,
  )
  Ok(PersistentSegmentTree::{ size: self.size, root, merge: self.merge })
}
