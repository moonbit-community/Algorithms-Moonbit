///| Introspective sort recursive core
///
///
/// Parameters:
/// * `depth` : The remaining allowed quicksort recursion depth
fn[T : Compare] introsort(arr : ArrayView[T], depth : Int) -> Unit {
  match arr.length() {
    0..=1 => ()
    2..=16 => insertion_sort(arr)
    _ if depth == 0 => heap_sort(arr)
    _ => {
      let pivot_index = partition(arr)
      introsort(arr[0:pivot_index], depth - 1)
      introsort(arr[pivot_index + 1:], depth - 1)
    }
  }
}
