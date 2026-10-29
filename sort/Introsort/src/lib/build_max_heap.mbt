///|
/// Build the largest heap
/// 
/// Start with the last non-leaf node and adjust the heap from the bottom up
fn[T : Compare] build_max_heap(arr : MutArrayView[T]) -> Unit {
  let n = arr.length()
  for i = n / 2 - 1; i >= 0; i = i - 1 {
    sift_down(arr, i, n)
  }
}
