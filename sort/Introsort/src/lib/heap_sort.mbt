/// Parameters:
/// * `start` : The starting index of the heap interval
/// * `end` : The end index of the heap interval
///
fn heap_sort(arr: Array[Int], start: Int, end: Int) -> Unit {
  let n = end - start + 1
  build_max_heap(arr, start, n)
  
  let mut last = n - 1
  while last > 0 {
    swap(arr, start, start + last)
    sift_down(arr, start, 0, last)
    last = last - 1
  }
}