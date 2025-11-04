///|
pub struct Queue[T] {
  elements : Array[T]
  mut start : Int
}

///|
pub fn[T : Default] Queue::new() -> Queue[T] {
  Queue::{ elements: Array::make(0, T::default()), start: 0 }
}

// Adds an element to the back of the queue

///|
pub fn[T] Queue::push(self : Queue[T], value : T) -> Unit {
  self.elements.push(value)
}

// Removes and returns the front element from the queue, or None if empty

///|
pub fn[T] Queue::pop(self : Queue[T]) -> T? {
  match self.is_empty() {
    true => None
    false => {
      self.start += 1
      Some(self.elements[self.start - 1])
    }
  }
}

// Returns a reference to the front element of the queue, or None if empty

///|
pub fn[T] Queue::front(self : Queue[T]) -> Ref[T]? {
  match self.elements.length() {
    0 => None
    _ => Some(@ref.new(self.elements[self.start]))
  }
}

// Returns a reference to the back element of the queue, or None if empty

///|
pub fn[T] Queue::back(self : Queue[T]) -> Ref[T]? {
  match self.is_empty() {
    true => None
    false => Some(@ref.new(self.elements.last().unwrap()))
  }
}

// Returns the number of elements in the queue

///|
pub fn[T] Queue::len(self : Queue[T]) -> Int {
  self.elements.length() - self.start
}

// Checks if the queue is empty

///|
pub fn[T] Queue::is_empty(self : Queue[T]) -> Bool {
  self.start > self.elements.length() - 1
}

// Clears all elements from the queue

///|
pub fn[T] Queue::clear(self : Queue[T]) -> Unit {
  self.elements.clear()
  self.start = 0
}

// Implementing the Default trait for Queue

///|
pub impl[T : Default] Default for Queue[T] with default() {
  Queue::new()
}
