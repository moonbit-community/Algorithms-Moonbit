///| Verify that the array is in ascending order
/// 'true' means sorted, 'false' means unsorted
///
pub fn[T:Compare] is_sorted(arr : ArrayView[T]) -> Bool {
  let n = arr.length()
  for i in 0..<(n - 1) {
    if arr[i] > arr[i + 1] {
      return false
    }
  }
  true
}
