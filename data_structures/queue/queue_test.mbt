///|
test "queue_test" {
  let queue : Queue[Int] = Queue::default()
  debug_inspect(queue.is_empty(), content="true")
  queue.push(8)
  queue.push(16)
  debug_inspect(!queue.is_empty(), content="true")
  @debug.assert_eq(queue.len(), 2)
  @debug.assert_eq(queue.front().unwrap().val, 8)
  @debug.assert_eq(queue.back().unwrap().val, 16)
  @debug.assert_eq(queue.pop(), Some(8))
  @debug.assert_eq(queue.len(), 1)
  @debug.assert_eq(queue.front().unwrap().val, 16)
  @debug.assert_eq(queue.back().unwrap().val, 16)
  queue.clear()
  @debug.assert_eq(queue.is_empty(), true)
  @debug.assert_eq(queue.len(), 0)
  @debug.assert_eq(queue.pop(), None)
}
