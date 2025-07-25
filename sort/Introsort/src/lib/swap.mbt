/// Parameters:
/// * `arr` : Array of targets
/// * `i` : The index of the first element
/// * `j` : The index of the second element
///
fn[T] swap(arr: ArrayView[T], i: Int, j: Int) -> Unit {
  let temp = arr[i]
  arr[i] = arr[j]
  arr[j] = temp
}