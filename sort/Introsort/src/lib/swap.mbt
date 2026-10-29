///|
/// Parameters:
/// * `arr` : Array of targets
/// * `i` : The index of the first element
/// * `j` : The index of the second element
///
fn[T] swap(arr : MutArrayView[T], i : Int32, j : Int32) -> Unit {
  let temp = arr[i]
  arr[i] = arr[j]
  arr[j] = temp
}
