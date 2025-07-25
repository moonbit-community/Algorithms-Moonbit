/// Quick Sort Partition Function (Lomuto Scheme)
///
/// 
/// Select the pivot and swap to the end
/// Divide elements smaller than the pivot to the left partition
/// Put the pivot back in the correct position
///
/// Returns the final position index of the pivot element
fn[T:Compare] partition(arr: ArrayView[T]) -> Int {
  let pivot_index = choose_pivot(arr)
  let pivot_value = arr[pivot_index]
  swap(arr, pivot_index, arr.length() - 1)
  
  let mut store_index = 0
  for i in 0..<arr.length(){
    if arr[i] < pivot_value {
      swap(arr, store_index, i)
      store_index += 1
    }
  }
  swap(arr, store_index, arr.length() - 1)
  store_index
}