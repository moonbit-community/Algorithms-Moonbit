///| Build the largest heap
///
/// 
/// Start with the last non-leaf node and adjust the heap from the bottom up
fn build_max_heap(arr : Array[Int], start : Int, n : Int) -> Unit {
  let mut i = n / 2 - 1
  while i >= 0 {
    sift_down(arr, start, i, n)
    i -= 1
  }
}
