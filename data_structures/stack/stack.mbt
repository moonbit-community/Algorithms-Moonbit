///|
pub(all) struct Stack[T] {
  stack : Array[T]
}

///|
pub fn[T] Stack::new() -> Stack[T] {
  { stack: [] }
}

///|
pub fn[T] Stack::size(self : Stack[T]) -> Int {
  self.stack.length()
}

///|
pub fn[T] Stack::is_empty(self : Stack[T]) -> Bool {
  self.stack.length() == 0
}

///|
pub fn[T] Stack::push(self : Stack[T], num : T) -> Unit {
  self.stack.push(num)
}

///|
pub fn[T] Stack::pop(self : Stack[T]) -> T? {
  self.stack.pop()
}

///|
pub fn[T] Stack::peek(self : Stack[T]) -> T? {
  if self.stack.length() == 0 {
    None
  } else {
    Some(self.stack[self.stack.length() - 1])
  }
}

///|
pub fn[T] Stack::to_array(self : Stack[T]) -> Array[T] {
  self.stack.copy()
}
