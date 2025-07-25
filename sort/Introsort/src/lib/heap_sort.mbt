/// Parameters:
/// * `start` : The starting index of the heap interval
/// * `end` : The end index of the heap interval
///
fn[T:Compare] heap_sort(arr: ArrayView[T]) -> Unit {
  build_max_heap(arr)
  
  let mut last = arr.length() - 1
  while last > 0 {
    swap(arr, 0, last)
    sift_down(arr, 0, last)
    last = last - 1
  }
}