///|
/// Introspective sort recursive core
///
///
/// Parameters:
/// * `depth` : The remaining allowed quicksort recursion depth
fn[T : Compare] introsort(arr : MutArrayView[T], depth : Int32) -> Unit {
  match arr.length() {
    0..<=1 => ()
    2..<=16 => insertion_sort(arr)
    _ if depth == 0 => heap_sort(arr)
    _ => {
      let pivot_index = partition(arr)
      introsort(arr.mut_view(end=pivot_index), depth - 1)
      introsort(arr.mut_view(start=pivot_index + 1), depth - 1)
    }
  }
}
