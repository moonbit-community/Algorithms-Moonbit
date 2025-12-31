///|
pub enum ChthollyTreeError {
  IndexOutOfBounds
  InvalidRange
} derive(Show, Eq)

///|
struct Interval {
  l : Int
  mut r : Int
  mut value : Int
} derive(Show, Eq)

///|
fn Interval::new(l : Int, r : Int, value : Int) -> Interval {
  Interval::{ l, r, value }
}

///|
pub struct ChthollyTree {
  size : Int
  mut intervals : Array[Interval]
} derive(Show)

///|
///Creates a Chtholly tree with a single interval `[0, length - 1]`.
///
///- `length` : length of the indexed range (0-based)
///- `value` : initial value to fill the range
pub fn ChthollyTree::new(length : Int, value : Int) -> ChthollyTree {
  if length <= 0 {
    return ChthollyTree::{ size: 0, intervals: [] }
  }
  ChthollyTree::{
    size: length,
    intervals: [Interval::new(0, length - 1, value)],
  }
}

///|
///Builds a Chtholly tree by compressing consecutive equal values.
///
///- `arr` : initial values for each position (0-based)
pub fn ChthollyTree::from_array(arr : Array[Int]) -> ChthollyTree {
  let size = arr.length()
  if size == 0 {
    return ChthollyTree::{ size: 0, intervals: [] }
  }
  let intervals : Array[Interval] = []
  let mut start = 0
  let mut current = arr[0]
  for i in 1..<size {
    if arr[i] != current {
      intervals.push(Interval::new(start, i - 1, current))
      start = i
      current = arr[i]
    }
  }
  intervals.push(Interval::new(start, size - 1, current))
  ChthollyTree::{ size, intervals }
}

///|
///Returns the length of the indexed range.
pub fn ChthollyTree::size(self : ChthollyTree) -> Int {
  self.size
}

///|
///Returns the number of stored intervals.
pub fn ChthollyTree::len(self : ChthollyTree) -> Int {
  self.intervals.length()
}

///|
///Checks whether the tree covers an empty range.
pub fn ChthollyTree::is_empty(self : ChthollyTree) -> Bool {
  self.size == 0
}

///|
///Gets the value at the given position.
pub fn ChthollyTree::value_at(
  self : ChthollyTree,
  pos : Int,
) -> Result[Int, ChthollyTreeError] {
  if pos < 0 || pos >= self.size {
    return Err(ChthollyTreeError::IndexOutOfBounds)
  }
  let index = self.find_index(pos)
  Ok(self.intervals[index].value)
}

///|
///Assigns all values in `[left, right]` to `value`.
pub fn ChthollyTree::assign(
  self : ChthollyTree,
  left : Int,
  right : Int,
  value : Int,
) -> Result[Unit, ChthollyTreeError] {
  match self.validate_range(left, right) {
    Err(err) => return Err(err)
    Ok(_) => ()
  }
  let right_index = self.split(right + 1)
  let left_index = self.split(left)
  self.remove_range(left_index, right_index - 1)
  self.insert_interval(left_index, Interval::new(left, right, value))
  self.normalize()
  Ok(())
}

///|
///Adds `delta` to each value in `[left, right]`.
pub fn ChthollyTree::add(
  self : ChthollyTree,
  left : Int,
  right : Int,
  delta : Int,
) -> Result[Unit, ChthollyTreeError] {
  match self.validate_range(left, right) {
    Err(err) => return Err(err)
    Ok(_) => ()
  }
  let right_index = self.split(right + 1)
  let left_index = self.split(left)
  for i in left_index..<right_index {
    self.intervals[i].value = self.intervals[i].value + delta
  }
  self.normalize()
  Ok(())
}

///|
///Computes the sum of values in `[left, right]`.
pub fn ChthollyTree::query_sum(
  self : ChthollyTree,
  left : Int,
  right : Int,
) -> Result[Int, ChthollyTreeError] {
  match self.validate_range(left, right) {
    Err(err) => return Err(err)
    Ok(_) => ()
  }
  let right_index = self.split(right + 1)
  let left_index = self.split(left)
  let mut total = 0
  for i in left_index..<right_index {
    let interval = self.intervals[i]
    total += interval.value * (interval.r - interval.l + 1)
  }
  self.normalize()
  Ok(total)
}

///|
fn ChthollyTree::validate_range(
  self : ChthollyTree,
  left : Int,
  right : Int,
) -> Result[Unit, ChthollyTreeError] {
  if left < 0 || right < 0 || left > right {
    return Err(ChthollyTreeError::InvalidRange)
  }
  if self.size == 0 || right >= self.size {
    return Err(ChthollyTreeError::IndexOutOfBounds)
  }
  Ok(())
}

///|
fn ChthollyTree::find_index(self : ChthollyTree, pos : Int) -> Int {
  let len = self.intervals.length()
  if len == 0 {
    return 0
  }
  let mut left = 0
  let mut right = len - 1
  while left <= right {
    let mid = (left + right) / 2
    let interval = self.intervals[mid]
    if pos < interval.l {
      right = mid - 1
    } else if pos > interval.r {
      left = mid + 1
    } else {
      return mid
    }
  }
  len
}

///|
fn ChthollyTree::insert_interval(
  self : ChthollyTree,
  index : Int,
  interval : Interval,
) -> Unit {
  let len = self.intervals.length()
  let updated : Array[Interval] = []
  for i in 0..<index {
    updated.push(self.intervals[i])
  }
  updated.push(interval)
  for i in index..<len {
    updated.push(self.intervals[i])
  }
  self.intervals = updated
}

///|
fn ChthollyTree::remove_range(
  self : ChthollyTree,
  start : Int,
  end : Int,
) -> Unit {
  if start > end {
    return
  }
  let len = self.intervals.length()
  let updated : Array[Interval] = []
  for i in 0..<start {
    updated.push(self.intervals[i])
  }
  for i in (end + 1)..<len {
    updated.push(self.intervals[i])
  }
  self.intervals = updated
}

///|
fn ChthollyTree::normalize(self : ChthollyTree) -> Unit {
  let len = self.intervals.length()
  if len <= 1 {
    return
  }
  let merged : Array[Interval] = []
  let mut current = self.intervals[0]
  for i in 1..<len {
    let next = self.intervals[i]
    if next.value == current.value && next.l == current.r + 1 {
      current.r = next.r
    } else {
      merged.push(current)
      current = next
    }
  }
  merged.push(current)
  self.intervals = merged
}

///|
fn ChthollyTree::split(self : ChthollyTree, pos : Int) -> Int {
  if pos <= 0 {
    return 0
  }
  if pos >= self.size {
    return self.intervals.length()
  }
  let index = self.find_index(pos)
  let interval = self.intervals[index]
  if interval.l == pos {
    return index
  }
  self.intervals[index].r = pos - 1
  let new_interval = Interval::new(pos, interval.r, interval.value)
  self.insert_interval(index + 1, new_interval)
  index + 1
}

///|
pub impl Default for ChthollyTree with default() {
  ChthollyTree::new(0, 0)
}
