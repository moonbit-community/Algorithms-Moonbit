/// Bubble sort is a simple sorting algorithm that sorts a list by repeatedly traversing it, 
/// comparing adjacent elements, and swapping their positions. 
/// The name of the algorithm comes from the way smaller elements 'bubble' up to the top of the list.
///
/// Parameters:
/// * `arr` - The array of integers to sort (`Array[Int]`)
///
/// Returns a sorted array
///
/// Example:
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
///
/// Implementation details:
/// The algorithm uses two nested loops:
/// 1. Outer loop: Controls the number of passes and checks for early termination
/// 2. Inner loop: Performs pairwise comparisons and swaps adjacent elements
/// 
/// The key optimizations implemented:
/// swapped : Detects when the array is fully sorted to terminate early
/// passes : Reduces the inner loop range after each pass

pub fn sort(arr: Array[Int]) -> Unit {
  let n = arr.length()
  if n <= 1 {
    return
  }
  
  let mut swapped = true
  let mut passes = 0

  while swapped {
    swapped = false

    let mut i = 0
    while i < n - 1 - passes {
      if arr[i] > arr[i + 1] {
        let temp = arr[i]
        arr[i] = arr[i + 1]
        arr[i + 1] = temp
        swapped = true
      }
      i += 1
    }
    passes += 1
  }
}