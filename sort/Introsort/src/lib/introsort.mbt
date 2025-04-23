/// Introspective sort recursive core
///
///
/// Parameters:
/// * `depth` : The remaining allowed quicksort recursion depth
fn introsort(arr: Array[Int], start: Int, end: Int, depth: Int) -> Unit {
  if start >= end {
    return
  }
  
  if end - start < 16 {
    insertion_sort(arr, start, end)
    return
  }
  
  if depth == 0 {
    heap_sort(arr, start, end)
    return
  }
  
  let pivot_index = partition(arr, start, end)
  introsort(arr, start, pivot_index - 1, depth - 1)
  introsort(arr, pivot_index + 1, end, depth - 1)
}