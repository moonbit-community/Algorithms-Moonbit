///|
test "heap_empty_test" {
  let heap : Heap[Int] = Heap::new(fn(_, _) { true })
  debug_inspect(heap.pop(), content="None")
}

///|
test "heap_max_test" {
  let heap = Heap::new(fn(x, y) { if x > y { true } else { false } })
  heap.add(4)
  heap.add(2)
  heap.add(9)
  heap.add(11)
  @debug.assert_eq(heap.len(), 4)
  @debug.assert_eq(heap.pop(), Some(11))
  @debug.assert_eq(heap.pop(), Some(9))
  @debug.assert_eq(heap.pop(), Some(4))
  heap.add(1)
  @debug.assert_eq(heap.pop(), Some(2))
  @debug.assert_eq(heap.pop(), Some(1))
  @debug.assert_eq(heap.pop(), None)
}

///|
test "heap_min_test" {
  let heap = Heap::new(fn(x, y) { if x < y { true } else { false } })
  heap.add(4)
  heap.add(2)
  heap.add(9)
  heap.add(11)
  @debug.assert_eq(heap.len(), 4)
  @debug.assert_eq(heap.pop(), Some(2))
  @debug.assert_eq(heap.pop(), Some(4))
  @debug.assert_eq(heap.pop(), Some(9))
  heap.add(1)
  @debug.assert_eq(heap.pop(), Some(1))
  @debug.assert_eq(heap.pop(), Some(11))
  @debug.assert_eq(heap.pop(), None)
}

///|
test "heap_min_from_vec_test" {
  let vec = [3, 1, 4, 1, 5, 9, 2, 6, 5]
  let heap = Heap::from_vec(vec, fn(x, y) { if x < y { true } else { false } })
  @debug.assert_eq(heap.len(), 9)
  @debug.assert_eq(heap.pop(), Some(1))
  @debug.assert_eq(heap.pop(), Some(1))
  @debug.assert_eq(heap.pop(), Some(2))
  heap.add(0)
  @debug.assert_eq(heap.pop(), Some(0))
}

///|
test "heap_max_from_vec_test" {
  let vec = [3, 1, 4, 1, 5, 9, 2, 6, 5]
  let heap = Heap::from_vec(vec, fn(x, y) { if x > y { true } else { false } })
  @debug.assert_eq(heap.len(), 9)
  @debug.assert_eq(heap.pop(), Some(9))
  @debug.assert_eq(heap.pop(), Some(6))
  @debug.assert_eq(heap.pop(), Some(5))
  heap.add(10)
  @debug.assert_eq(heap.pop(), Some(10))
}
