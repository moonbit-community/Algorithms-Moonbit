/// Elemental Sinking Operation (Maintaining Maximum Heap Properties)
///
/// Parameters:
/// * `i` : Node index to be adjusted 
/// * `n` : The effective size of the current heap
fn sift_down(arr: Array[Int], start: Int, i: Int, n: Int) -> Unit {
  let mut parent = i
  while true {  
    let left = 2 * parent + 1
    let right = 2 * parent + 2
    let mut max = parent
    
    if left < n && arr[start + left] > arr[start + max] {
      max = left
    }
    if right < n && arr[start + right] > arr[start + max] {
      max = right
    }
    if max == parent {
      break
    }
    
    swap(arr, start + parent, start + max)
    parent = max
  }
}