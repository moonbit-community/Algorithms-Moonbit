///| The three numbers are taken in the middle method to select the pivot element index
///
fn choose_pivot(arr : Array[Int], start : Int, end : Int) -> Int {
  let mid = start + (end - start) / 2
  let a = arr[start]
  let b = arr[mid]
  let c = arr[end]
  if (a < b && b < c) || (c < b && b < a) {
    mid
  } else if (b < a && a < c) || (c < a && a < b) {
    start
  } else {
    end
  }
}
