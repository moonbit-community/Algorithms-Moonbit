/// Quick Sort Partition Function (Lomuto Scheme)
///
/// 
/// Select the pivot and swap to the end
/// Divide elements smaller than the pivot to the left partition
/// Put the pivot back in the correct position
///
/// Returns the final position index of the pivot element
fn partition(arr: Array[Int], start: Int, end: Int) -> Int {
  let pivot_index = choose_pivot(arr, start, end)
  let pivot_value = arr[pivot_index]
  swap(arr, pivot_index, end)
  
  let mut store_index = start
  let mut i = start
  while i < end {
    if arr[i] < pivot_value {
      swap(arr, store_index, i)
      store_index += 1
    }
    i += 1
  }
  swap(arr, store_index, end)
  store_index
}