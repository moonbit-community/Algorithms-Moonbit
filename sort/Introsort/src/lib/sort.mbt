/// The implementation of the introsort algorithm combines a hybrid sorting algorithm of quicksort, heap sorting, and insert sorting.
/// 
/// Parameters:
/// * `arr` - An array of variable integers to sort (`Array[Int]`)
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
/// Implement a three-tier strategy:
/// Quick Sort: The main sorting algorithm
/// Heap Sort: Triggers when the recursion depth exceeds '2 * log2(n)' to prevent quicksort degradation
/// Insert Sort: Used when partition size ≤16 to reduce recursive overhead
///
/// Reference implementation: 'std::sort' algorithm design for C++ STL

pub fn sort(arr: Array[Int]) -> Unit {
  let n = arr.length()
  if n <= 1 {
    return
  }
  
  let max_depth = 2 * log2(n)
  introsort(arr, 0, n - 1, max_depth)
}