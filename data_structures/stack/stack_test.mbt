///|
test "stack operations" {
  let s = Stack::new()
  s.push(1)
  s.push(2)
  s.push(3)
  debug_inspect(s.size(), content="3")
  debug_inspect(s.peek(), content="Some(3)")
  debug_inspect(s.pop(), content="Some(3)")
  debug_inspect(s.pop(), content="Some(2)")
  debug_inspect(s.is_empty(), content="false")
  debug_inspect(s.pop(), content="Some(1)")
  debug_inspect(s.is_empty(), content="true")
  debug_inspect(s.pop(), content="None")
}
