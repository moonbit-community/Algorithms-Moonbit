/// shell sorting is a type of insertion sorting, which is an improvement on the direct insertion sorting algorithm.
/// It does this by comparing elements at a certain interval from each other,
/// and the distance used for each comparison decreases as the algorithm progresses, until only the last order of adjacent elements is compared.
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
/// The algorithm uses three nested loops:
/// 1. Outer loop: Controls the gap size and reduces it over time
/// 2. Middle loop: Processes each subarray defined by the current gap
/// 3. Inner loop: Performs insertion sort within each subarray
/// 
/// The key characteristics implemented:
/// gap : Controls the spacing between compared elements, starting at n/2 and halving each pass
/// 
/// Optimization details:
/// 1. Uses the Shell sequence (gap = n/2, then gap/2 each time) for efficient gap reduction
/// 2. Performs insertion sort on gapped subarrays, which is efficient for partially sorted data
/// 3. Reduces the gap size over time, transitioning from coarse to fine-grained sorting

pub fn sort(arr: Array[Int]) -> Unit {
  let n = arr.length()
  let mut gap = n / 2  
  
  while gap > 0 {
    let mut i = gap    
    
    while i < n {
      let temp = arr[i]
      let mut j = i    
      
      while j >= gap && arr[j - gap] > temp {
        arr[j] = arr[j - gap]  
        j = j - gap            
      }
      
      arr[j] = temp
      i = i + 1
    }
    
    gap = gap / 2
  }
}