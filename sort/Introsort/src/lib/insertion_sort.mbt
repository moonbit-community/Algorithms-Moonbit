///| Parameters:
/// * `start` : Sort interval start index (included)
/// * `end` : End of Sort Range Index (inclusive)
///
fn[T:Compare] insertion_sort(arr : ArrayView[T]) -> Unit {
  for i in 1..<arr.length() {
    let key = arr[i]
    let mut j = i - 1
    while j >= 0 && arr[j] > key {
      arr[j + 1] = arr[j]
      j -= 1
    }
    arr[j + 1] = key
  }
}
