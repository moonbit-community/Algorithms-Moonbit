///| Build the largest heap
/// 
/// Start with the last non-leaf node and adjust the heap from the bottom up
fn[T : Compare] build_max_heap(arr : ArrayView[T]) -> Unit {
  let n = arr.length()
  for i in (n / 2 - 1)..=0 {
    sift_down(arr, i, n)
  }
}
