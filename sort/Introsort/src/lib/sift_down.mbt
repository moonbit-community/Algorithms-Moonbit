/// Elemental Sinking Operation (Maintaining Maximum Heap Properties)
///
/// Parameters:
/// * `i` : Node index to be adjusted 
/// * `n` : The effective size of the current heap
fn[T:Compare] sift_down(arr: ArrayView[T], i: Int, n: Int) -> Unit {
  let mut parent = i
  while true {  
    let left = 2 * parent + 1
    let right = 2 * parent + 2
    let mut max = parent
    
    if left < n && arr[left] > arr[max] {
      max = left
    }
    if right < n && arr[right] > arr[max] {
      max = right
    }
    if max == parent {
      break
    }
    
    swap(arr, parent, max)
    parent = max
  }
}