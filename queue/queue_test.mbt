///|
test "queue_test" {
  let queue : Queue[Int] = Queue::default()
  inspect(queue.is_empty(), content="true")
  queue.push(8)
  queue.push(16)
  inspect(!queue.is_empty(), content="true")
  assert_eq(queue.len(), 2)
  assert_eq(queue.front().unwrap().val, 8)
  assert_eq(queue.back().unwrap().val, 16)
  assert_eq(queue.pop(), Some(8))
  assert_eq(queue.len(), 1)
  assert_eq(queue.front().unwrap().val, 16)
  assert_eq(queue.back().unwrap().val, 16)
  queue.clear()
  assert_eq(queue.is_empty(), true)
  assert_eq(queue.len(), 0)
  assert_eq(queue.pop(), None)
}
