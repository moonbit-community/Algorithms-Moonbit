///| Min Max

///| Maximum value
/// 
/// # Parameters
/// 
/// - `a` : value to compare
/// - `b`: value to compare
/// 
/// # Returns
/// 
/// - `T` : maximum value
/// 
/// # Example
/// ```
/// max(1, 2) -> 2
/// ```
pub fn max[T : Compare](a : T, b : T) -> T {
  if a > b {
    a
  } else {
    b
  }
}

///| Minimum value
/// 
/// # Parameters
/// 
/// - `a` : value to compare
/// - `b`: value to compare
/// 
/// # Returns
/// 
/// - `T` : minimum value
/// 
/// # Example
/// ```
/// min(1, 2) -> 1
/// ```
pub fn min[T : Compare](a : T, b : T) -> T {
  if a < b {
    a
  } else {
    b
  }
}

///| Maximum value in array
/// 
/// # Parameters
/// 
/// - `data` : Array[T]
/// 
/// # Returns
/// 
/// - `T` : maximum value in array
/// 
/// # Example
/// ```
/// test "max_element" {
///   let arr = [1,2,3,4,5]
///   inspect!(@algorithm.max_element(arr), content="5")
///   let arr = [1.1,2.4,3.9,4,5.9,1.0]
///   inspect!(@algorithm.max_element(arr), content="5.9")
/// }
/// ```
pub fn max_element[T : Compare](data : Array[T]) -> T {
  if data.length() == 0 {
    abort("Empty array")
  }
  data.fold(init=data[0], fn(mx, x) { if x > mx { x } else { mx } })
}

///| Minimum value in array
/// 
/// # Parameters
/// 
/// - `data` : Array[T]
/// 
/// # Returns
/// 
/// - `T` : minimum value in array
/// 
/// # Example
/// ```
/// test "min_element" {
///   let arr = [1,2,3,4,5]
///   inspect!(@algorithm.min_element(arr), content="1")
///   let arr = [1.1,2.4,3.9,4,5.9,1.2]
///   inspect!(@algorithm.min_element(arr), content="1.1")
/// }
/// ```
pub fn min_element[T : Compare](data : Array[T]) -> T {
  if data.length() == 0 {
    abort("Empty array")
  }
  data.fold(init=data[0], fn(mx, x) { if x < mx { x } else { mx } })
}

///| Binary Search

///| Find first index of element in array that not less than value
/// 
/// # Parameters
/// 
/// - `data` : The array need to be search
/// - `value`: The value need to compare
/// 
/// # Returns
/// 
/// - `Int` : first index in array that not less than value
/// 
/// /// # Example
/// ```
/// test "lower_bound" {
///   let arr = [1,2,3,4,5]
///   inspect!(@algorithm.lower_bound(arr, 7), content="5")
///   let arr = [1.1, 2, 3.5, 9]
///   inspect!(@algorithm.lower_bound(arr, 1.2), content="1")
///  }
/// ```
pub fn lower_bound[T : Compare](data : Array[T], value : T) -> Int {
  let mut count = data.length()
  let mut first = 0
  while count > 0 {
    let step = count / 2
    let it = first + step
    if data[it] < value {
      first = it + 1
      count -= step + 1
    } else {
      count = step
    }
  }
  first
}

///| Find first index of element in array that bigger than value
/// 
/// # Parameters
/// 
/// - `data` : The array need to be search
/// - `value`: The value need to compare
/// 
/// # Returns
/// 
/// - `Int` : first index in array that bigger than value
/// 
/// # Example
/// ```
/// test "upper_bound" {
///   let arr = [1,2,3,4,5]
///   inspect!(@algorithm.upper_bound(arr, -1), content="0")
///   inspect!(@algorithm.upper_bound(arr, 7), content="5")
/// }
/// ```
pub fn upper_bound[T : Compare](data : Array[T], value : T) -> Int {
  let mut count = data.length()
  let mut first = 0
  while count > 0 {
    let step = count / 2
    let it = first + step
    if data[it] <= value {
      first = it + 1
      count -= step + 1
    } else {
      count = step
    }
  }
  first
}

///| Find whether a value in the array
/// 
/// # Parameters
/// 
/// - `data` : The array need to be search
/// - `value`: The value need to find
/// 
/// # Returns
/// 
/// - `Bool` : value in or not in array
/// 
/// # Example
/// ```
/// test "binary_search" {
///   let arr = [1,2,3,4,5]
///   inspect!(@algorithm.binary_search(arr, 1), content="true")
///   inspect!(@algorithm.binary_search(arr, 6), content="false")
/// }
/// ```
pub fn binary_search[T : Compare](data : Array[T], value : T) -> Bool {
  let first = lower_bound(data, value)
  first != data.length() && data[first] == value
}

///| Find range of array equal to value
/// 
/// # Parameters
/// 
/// - `data` : The array need to be search
/// - `value`: The value need to find
/// 
/// # Returns
/// 
/// - `(Int, Int)` : Range of array equal to value
///
/// # Example
/// ```
/// test "equal_range" {
///   let arr = [1,2,2,2,3,4,5]
///   inspect!(@algorithm.equal_range(arr, 2), content="(1, 3)")
///   inspect!(@algorithm.equal_range(arr, 7), content="(-1, -1)")
/// }
/// ```
pub fn equal_range[T : Compare](data : Array[T], value : T) -> (Int, Int) {
  let l = lower_bound(data, value)
  let r = upper_bound(data, value)
  if l > r - 1 {
    return (-1, -1)
  }
  (l, r - 1)
}

///| Merge

///| Merge two sorted array in sequence
/// 
/// # Parameters
/// 
/// - `data1` : First array
/// - `data2`: Second array
/// 
/// # Returns
/// 
/// - `Array[T]` : Merged array of data1 and data2
///
/// # Example
/// ```
/// test "merge" {
///   let arr1 = [1,2,5]
///   let arr2 = [3,4,6]
///   inspect!(@algorithm.merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
///   let arr1 = [1,2,3]
///   let arr2 = [4,5,6]
///   inspect!(@algorithm.merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
/// }
/// ```
pub fn merge[T : Compare](data1 : Array[T], data2 : Array[T]) -> Array[T] {
  let len1 = data1.length()
  let len2 = data2.length()
  let mut res = []
  let mut i = 0
  let mut j = 0
  for ; i < len1; {
    if j == len2 {
      return res.iter().concat(data1[i:].iter()).collect()
    }
    if data1[i] < data2[j] {
      res += [data1[i]]
      i += 1
    } else {
      res += [data2[j]]
      j += 1
    }
  }
  res.iter().concat(data2[j:].iter()).collect()
}

///|

///| Fast Exponentiation
/// 
/// # Parameters
/// 
/// - `base` : base
/// - `power`: exponent
/// 
/// # Returns
/// 
/// - `Int64` : value of Power operation
/// 
/// # Example
/// ```
/// let qpow = quick_pow(2, 10)
/// ```
pub fn quick_pow(base : Int, power : Int, mod~ : Int = 1) -> Int64 {
  let mut b : Int64 = base.to_int64()
  let mut p : Int = power
  let mut ret : Int64 = 1
  while p != 0 {
    if (p & 1) != 0 {
      ret = ret * b % mod.to_int64()
    }
    b = b * b % mod.to_int64()
    p /= 2
  }
  ret % mod.to_int64()
}

///|
pub(all) struct Point {
  x : Int
  y : Int
} derive(Show)

///| Calculate max manhattan distance
/// 
/// # Parameters
/// 
/// - `points` : Points array
/// 
/// # Returns
/// 
/// - `Int` : max manhattan distance between all points
/// 
/// # Example
/// ```
/// test "max_manhattan_distance" { 
///     let arr = [@algorithm.Point::{x:0,y:0}, @algorithm.Point::{x:1,y:0}, @algorithm.Point::{x:1,y:1}]
///     inspect!(@algorithm.max_manhattan_distance(arr), content="2")
/// }
/// ```
pub fn max_manhattan_distance(points : Array[Point]) -> Int {
  let mut a = @int.min_value
  let mut b = @int.max_value
  let mut c = @int.min_value
  let mut d = @int.max_value
  for i = 0; i < points.length(); i = i + 1 {
    let x = points[i].x
    let y = points[i].y
    a = max(a, x + y)
    b = min(b, x + y)
    c = max(c, x - y)
    d = min(d, x - y)
  }
  max(a - b, c - d)
}

///| Calculate Inverse Element
/// 
/// # Parameters
/// 
/// - `x` : value to calculate inverse
/// - `mod`
/// 
/// # Returns
/// 
/// - `Int` : inverse of x
/// 
/// # Example
/// ```
/// test "inv" { 
///     inspect!(@algorithm.inv(2, 1000_000_007), content="500000004")
/// }
/// ```
pub fn inv(x : Int, mod : Int) -> Int {
  quick_pow(x, mod - 2, mod~).to_int()
}

///|sort
