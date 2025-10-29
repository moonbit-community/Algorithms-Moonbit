/// The basic idea of selection sorting is to select the smallest (or largest) element from the data 
/// to be sorted each time and place it at the end of the sorted sequence until all the data is sorted.
///
/// Parameters:
/// * `arr` - The array of integers to sort (`Array[Int]`)
///
/// Returns: Unit (sorts the array in-place)
/// 
/// Example :
///
/// ```moonbit
/// test "基本排序测试" {
///   let arr = [3, 1, 4, 1, 5, 9, 2, 6].to_array()
///   sort(arr)
///   inspect(arr, content="[1, 1, 2, 3, 4, 5, 6, 9]")
/// }
///
/// test "空数组测试" {
///   let arr = [].to_array()
///   sort(arr)
///   inspect(arr, content="[]")
/// }
///
/// test "已排序数组" {
///   let arr = [1, 2, 3, 4, 5].to_array()
///   sort(arr)
///   inspect(arr, content="[1, 2, 3, 4, 5]")
/// }
///
/// test "逆序数组" {
///   let arr = [5, 4, 3, 2, 1].to_array()
///   sort(arr)
///   inspect(arr, content="[1, 2, 3, 4, 5]")
/// }
///
/// test "包含负数的数组" {
///   let arr = [-3, 1, -4, 2, 0].to_array()
///   sort(arr)
///   inspect(arr, content="[-4, -3, 0, 1, 2]")
/// }
/// ```
/// Implementation details:
/// The algorithm uses two nested loops:
/// 1. Outer loop: Traverses through the entire array
/// 2. Inner loop: Finds the minimum element in the unsorted portion
/// 
/// The key optimizations implemented:
/// min_idx : Tracks the index of the minimum element found in each pass
///
///
pub fn sort(arr: Array[Int]) -> Unit {
  let n = arr.length()
  if n <= 1 {
    return
  }
  
  let mut i = 0
  while i < n - 1 {
    let mut min_idx = i
    
    let mut j = i + 1
    while j < n {
      if arr[j] < arr[min_idx] {
        min_idx = j
      }
      j += 1
    }
    
    if min_idx != i {
      let temp = arr[i]
      arr[i] = arr[min_idx]
      arr[min_idx] = temp
    }
    
    i += 1
  }
}