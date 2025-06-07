/// Parameters:
/// * `start` : Sort interval start index (included)
/// * `end` : End of Sort Range Index (inclusive)
///
fn insertion_sort(arr: Array[Int], start: Int, end: Int) -> Unit {
  let mut i = start + 1
  while i <= end {
    let key = arr[i]
    let mut j = i - 1
    while j >= start && arr[j] > key {
      arr[j + 1] = arr[j]
      j = j - 1
    }
    arr[j + 1] = key
    i = i + 1
  }
}