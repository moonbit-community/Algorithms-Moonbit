/// Verify that the array is in ascending order
/// 'true' means sorted, 'false' means unsorted
///
/// Example:
/// ```moonbit
/// test "已排序检查" {
///   let arr = [1, 2, 3].to_array()
///   inspect!(is_sorted(arr), content="true")
/// }
/// ```
pub fn is_sorted(arr: Array[Int]) -> Bool {
  let n = arr.length()
  let mut i = 0
  while i < n - 1 {
    if arr[i] > arr[i + 1] {
      return false
    }
    i += 1
  }
  true
}