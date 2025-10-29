///|
test "stack operations" {
  let s = Stack::new()
  s.push(1)
  s.push(2)
  s.push(3)
  inspect(s.size(), content="3")
  inspect(s.peek(), content="Some(3)")
  inspect(s.pop(), content="Some(3)")
  inspect(s.pop(), content="Some(2)")
  inspect(s.is_empty(), content="false")
  inspect(s.pop(), content="Some(1)")
  inspect(s.is_empty(), content="true")
  inspect(s.pop(), content="None")
}
