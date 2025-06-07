/// Parameters:
/// * `arr` : Array of targets
/// * `i` : The index of the first element
/// * `j` : The index of the second element
///
fn swap(arr: Array[Int], i: Int, j: Int) -> Unit {
  let temp = arr[i]
  arr[i] = arr[j]
  arr[j] = temp
}