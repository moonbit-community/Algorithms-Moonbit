///|
pub struct Heap[T] {
  items : Array[T]
  comparator : (T, T) -> Bool
}

///|
/// Creates a new, empty heap with a custom comparator function.
///
/// # Parameters
/// - `comparator`: A function that defines the heap's ordering.
///
/// # Returns
/// A new `Heap` instance.
pub fn[T] Heap::new(comparator : (T, T) -> Bool) -> Heap[T] {
  Heap::{ items: Array::new(), comparator }
}

///|
/// Creates a heap from a vector and a custom comparator function.
///
/// # Parameters
/// - `items`: A vector of items to be turned into a heap.
/// - `comparator`: A function that defines the heap's ordering.
///
/// # Returns
/// A `Heap` instance with the elements from the provided vector.
pub fn[T] Heap::from_vec(
  items : Array[T],
  comparator : (T, T) -> Bool,
) -> Heap[T] {
  let heap = Heap::{ items, comparator }
  heap.build_heap()
  heap
}

///|
/// Constructs the heap from an unsorted vector by applying the heapify process.
pub fn[T] Heap::build_heap(self : Heap[T]) -> Unit {
  let n = self.items.length()
  if n < 2 {
    return
  }
  let mut idx = n / 2 - 1
  while true {
    self.heapify_down(idx)
    if idx == 0 {
      break
    }
    idx -= 1
  }
}

///|
/// Returns the number of elements in the heap.
///
/// # Returns
/// The number of elements in the heap.
pub fn[T] Heap::len(self : Heap[T]) -> Int {
  self.items.length()
}

///|
/// Checks if the heap is empty.
///
/// # Returns
/// `true` if the heap is empty, `false` otherwise.
pub fn[T] Heap::is_empty(self : Heap[T]) -> Bool {
  self.len() == 0
}

///|
/// Adds a new element to the heap and maintains the heap property.
///
/// # Parameters
/// - `value`: The value to add to the heap.
pub fn[T] Heap::add(self : Heap[T], value : T) -> Unit {
  self.items.push(value)
  self.heapify_up(self.len() - 1)
}

///|
/// Removes and returns the root element from the heap.
///
/// # Returns
/// The root element if the heap is not empty, otherwise `None`.
pub fn[T] Heap::pop(self : Heap[T]) -> T? {
  if self.is_empty() {
    return None
  }
  let next = if self.items.length() > 0 {
    let val = self.items[0]
    let last = self.items.pop().unwrap()
    if self.items.length() > 0 {
      self.items[0] = last
    }
    Some(val)
  } else {
    None
  }
  if !self.is_empty() {
    self.heapify_down(0)
  }
  next
}

///|
/// Returns an iterator over the elements in the heap.
///
/// # Returns
/// An iterator over the elements in the heap, in their internal order.
pub fn[T] Heap::iter(self : Heap[T]) -> Iter[T] {
  self.items.iter()
}

///|
/// Moves an element upwards to restore the heap property.
///
/// # Parameters
/// - `idx`: The index of the element to heapify up.
fn[T] Heap::heapify_up(self : Heap[T], idx : Int) -> Unit {
  let mut idx0 = idx
  while self.parent_idx(idx0) is Some(pdx) { // while-let 等价写法
    if (self.comparator)(self.items[idx0], self.items[pdx]) {
      let tmp = self.items[idx0]
      self.items[idx0] = self.items[pdx]
      self.items[pdx] = tmp
      idx0 = pdx
    } else {
      break
    }
  }
}

///|
/// Moves an element downwards to restore the heap property.
///
/// # Parameters
/// - `idx`: The index of the element to heapify down.
fn[T] Heap::heapify_down(self : Heap[T], idx : Int) -> Unit {
  let mut idx0 = idx
  while self.children_present(idx0) {
    let cdx = if self.right_child_idx(idx0) >= self.len() {
      self.left_child_idx(idx0)
    } else {
      let ldx = self.left_child_idx(idx0)
      let rdx = self.right_child_idx(idx0)
      if (self.comparator)(self.items[ldx], self.items[rdx]) {
        ldx
      } else {
        rdx
      }
    }
    if (self.comparator)(self.items[cdx], self.items[idx0]) {
      self.items.swap(idx0, cdx)
      idx0 = cdx
    } else {
      break
    }
  }
}

///|
/// Returns the index of the parent of the element at `idx`.
///
/// # Parameters
/// - `idx`: The index of the element.
///
/// # Returns
/// The index of the parent element if it exists, otherwise `None`.
fn[T] Heap::parent_idx(_self : Heap[T], idx : Int) -> Int? {
  if idx > 0 {
    Some((idx - 1) / 2)
  } else {
    None
  }
}

///|
/// Checks if the element at `idx` has children.
///
/// # Parameters
/// - `idx`: The index of the element.
///
/// # Returns
/// `true` if the element has children, `false` otherwise.
fn[T] Heap::children_present(self : Heap[T], idx : Int) -> Bool {
  self.left_child_idx(idx) < self.len()
}

///|
/// Returns the index of the left child of the element at `idx`.
///
/// # Parameters
/// - `idx`: The index of the element.
///
/// # Returns
/// The index of the left child.
fn[T] Heap::left_child_idx(_self : Heap[T], idx : Int) -> Int {
  idx * 2 + 1
}

///|
/// Returns the index of the right child of the element at `idx`.
///
/// # Parameters
/// - `idx`: The index of the element.
///
/// # Returns
/// The index of the right child.
fn[T] Heap::right_child_idx(self : Heap[T], idx : Int) -> Int {
  self.left_child_idx(idx) + 1
}
