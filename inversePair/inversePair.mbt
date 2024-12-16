fn merge[T : Compare](a : Array[T], b : Array[T], l : Int, r : Int) -> Int {
  if l >= r {
    return 0
  }
  let mut res = 0
  let mid = (l + r) / 2
  res += merge(a, b, l, mid)
  res += merge(a, b, mid + 1, r)

  let mut i = l
  let mut j = mid + 1
  let mut idx = l
  while i <= mid && j <= r {
    if a[i] > a[j] {
      res += mid - i + 1
      b[idx] = a[j]
      j += 1
    } else {
      b[idx] = a[i]
      i += 1
    }
    idx += 1
  }
  while i <= mid {
    b[idx] = a[i]
    i += 1
    idx += 1
  }
  while j <= r {
    b[idx] = a[j]
    j += 1
    idx += 1
  }
  for i in l..=r {
    a[i] = b[i]
  }
  res
}


/// Inverse Pair
/// 
/// # Parameters
/// 
/// - `arr` : The array to find inverse pairs
/// 
/// # Returns
/// 
/// - `Int` : Number of inverse pairs in the array
///
/// # Example
/// ```
/// test {
///   let arr = [2, 4, 1, 3, 5]
///   inspect!(inverse_pair(arr), content="3")
///   let arr2 = [5, 4, 3, 2, 1]
///   inspect!(inverse_pair(arr2), content="10")
/// }
/// ```
pub fn inverse_pair[T : Compare](arr : Array[T]) -> Int {
  merge(arr, Array::make(arr.length(), arr[0]), 0, arr.length() - 1)
}

