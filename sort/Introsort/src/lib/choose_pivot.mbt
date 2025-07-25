///| The three numbers are taken in the middle method to select the pivot element index
///
fn[T:Compare] choose_pivot(arr : ArrayView[T]) -> Int {
  let mid = 0 + (arr.length() - 0) / 2
  let a = arr[0]
  let b = arr[mid]
  let c = arr[arr.length() - 1]
  if (a < b && b < c) || (c < b && b < a) {
    mid
  } else if (b < a && a < c) || (c < a && a < b) {
    0
  } else {
    arr.length() - 1
  }
}
