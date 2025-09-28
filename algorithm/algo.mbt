///| Min Max

///|
/// Maximum value
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
/// //max(1, 2) -> 2
/// ```
pub fn[T : Compare] max(a : T, b : T) -> T {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// Minimum value
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
/// //min(1, 2) -> 1
/// ```
pub fn[T : Compare] min(a : T, b : T) -> T {
  if a < b {
    a
  } else {
    b
  }
}

///|
/// Maximum value in array
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
///   let arr = [1,2,3,4,5]
///   inspect(max_element(arr), content="5")
///   let arr = [1.1,2.4,3.9,4.0,5.9,1.0]
///   inspect(max_element(arr), content="5.9")
/// ```
pub fn[T : Compare] max_element(data : Array[T]) -> T {
  if data.length() == 0 {
    abort("Empty array")
  }
  data.fold(init=data[0], fn(mx, x) { if x > mx { x } else { mx } })
}

///|
/// Minimum value in array
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
///   let arr = [1,2,3,4,5]
///   inspect(min_element(arr), content="1")
///   let arr = [1.1,2.4,3.9,4.0,5.9,1.2]
///   inspect(min_element(arr), content="1.1")
/// ```
pub fn[T : Compare] min_element(data : Array[T]) -> T {
  if data.length() == 0 {
    abort("Empty array")
  }
  data.fold(init=data[0], fn(mx, x) { if x < mx { x } else { mx } })
}

///| Binary Search

///|
/// Find first index of element in array that not less than value
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
///   let arr = [1,2,3,4,5]
///   inspect(lower_bound(arr, 7), content="5")
///   let arr = [1.1, 2.0, 3.5, 9.0]
///   inspect(lower_bound(arr, 1.2), content="1")
/// ```
pub fn[T : Compare] lower_bound(data : Array[T], value : T) -> Int {
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

///|
/// Find first index of element in array that bigger than value
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
///   let arr = [1,2,3,4,5]
///   inspect(upper_bound(arr, -1), content="0")
///   inspect(upper_bound(arr, 7), content="5")
/// ```
pub fn[T : Compare] upper_bound(data : Array[T], value : T) -> Int {
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

///|
/// Find whether a value in the array
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
///   let arr = [1,2,3,4,5]
///   inspect(binary_search(arr, 1), content="true")
///   inspect(binary_search(arr, 6), content="false")
/// ```
pub fn[T : Compare] binary_search(data : Array[T], value : T) -> Bool {
  let first = lower_bound(data, value)
  first != data.length() && data[first] == value
}

///|
/// Find range of array equal to value
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
///   let arr = [1,2,2,2,3,4,5]
///   inspect(equal_range(arr, 2), content="(1, 3)")
///   inspect(equal_range(arr, 7), content="(-1, -1)")
/// ```
pub fn[T : Compare] equal_range(data : Array[T], value : T) -> (Int, Int) {
  let l = lower_bound(data, value)
  let r = upper_bound(data, value)
  if l > r - 1 {
    return (-1, -1)
  }
  (l, r - 1)
}

///| Merge

///|
/// Merge two sorted array in sequence
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
///   let arr1 = [1,2,5]
///   let arr2 = [3,4,6]
///   inspect(merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
///   let arr1 = [1,2,3]
///   let arr2 = [4,5,6]
///   inspect(merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
/// ```
pub fn[T : Compare] merge(data1 : Array[T], data2 : Array[T]) -> Array[T] {
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
/// Fast Exponentiation
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
/// assert_eq(quick_pow(2, 10), 1024)
/// ```
pub fn quick_pow(base : Int, exp : Int) -> Int64 {
  let base_int64 = base.to_int64()
  if exp == 0 {
    1
  } else if exp == 1 {
    base_int64
  } else if exp % 2 == 0 {
    let half_pow = quick_pow(base, exp / 2)
    half_pow * half_pow
  } else {
    let half_pow = quick_pow(base, (exp - 1) / 2)
    half_pow * half_pow * base_int64
  }
}

///|
pub(all) struct Point {
  x : Int
  y : Int
} derive(Show)

///|
/// Calculate max manhattan distance
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
///     let arr = [Point::{x:0,y:0}, Point::{x:1,y:0}, Point::{x:1,y:1}]
///     inspect(max_manhattan_distance(arr), content="2")
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

///|
/// Calculates the Greatest Common Divisor (GCD) of two integers using Euclidean
/// algorithm.
///
/// Parameters:
///
/// * `first` : First integer.
/// * `second` : Second integer.
///
/// Returns the greatest common divisor of the two integers.
///
/// Example:
///
/// ```
/// 
///inspect(@algorithm.gcd(12, 18), content="6")
///inspect(@algorithm.gcd(17, 23), content="1")
/// 
/// ```
pub fn gcd(a : Int, b : Int) -> Int {
  if b == 0 {
    a
  } else {
    gcd(b, a % b)
  }
}

///|
/// Calculates the Lowest Common Multiple (LCM) of two integers.
///
/// Parameters:
///
/// * `first` : First integer.
/// * `second` : Second integer.
///
/// Returns the lowest common multiple of the two integers.
///
/// Example:
///
/// ```
/// 
///inspect(@algorithm.lcm(2, 3), content="6")
///inspect(@algorithm.lcm(17, 20), content="340")
/// 
/// ```
pub fn lcm(a : Int, b : Int) -> Int {
  a * b / gcd(a, b)
}

///|
/// Implements the Extended Euclidean Algorithm to find the greatest common
/// divisor (GCD) of two integers and the coefficients of Bézout's identity.
///
/// Parameters:
///
/// * `first` : First integer input
/// * `second` : Second integer input
///
/// Returns a tuple `(gcd, x, y)` where:
///
/// * `gcd` is the greatest common divisor of the two inputs
/// * `x` and `y` are the coefficients satisfying Bézout's identity: `first * x +
/// second * y = gcd`
///
/// Example:
///
/// ```
/// inspect(ext_euc(5, 7), content="(1, 3, -2)")
/// ```
pub fn ext_euc(a : Int, b : Int) -> (Int, Int, Int) {
  if b == 0 {
    (a, 1, 0)
  } else {
    let (gcd, x, y) = ext_euc(b, a % b)
    let x_ = y
    let y_ = x - a / b * y
    (gcd, x_, y_)
  }
}

///|
/// Calculate Inverse Element
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
/// assert_eq(mod_inverse(2, 1000_000_007), 500000004)
/// assert_eq(mod_inverse(3, 26), 9)
/// 
/// ```
pub fn mod_inverse(a : Int, mod : Int) -> Int {
  let (_, x, _) = ext_euc(a, mod)
  if x < 0 {
    (1 - x) % mod
  } else {
    x % mod
  }
}
