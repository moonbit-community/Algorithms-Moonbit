///|
struct Catalan {
  values : Array[Int64]
}

///|
/// Construct a Catalan number table up to `max_n`.
///
/// # Parameters
/// - `max_n`: the maximum index that should be precomputed. Must be non-negative.
///
/// # Returns
/// - `Catalan`: a table containing Catalan numbers from `C_0` to `C_{max_n}`.
///
/// # Example
/// ```
/// let catalan = Catalan::new(5)
/// inspect(catalan.nth(4), content="14")
/// ```
pub fn Catalan::new(max_n : Int) -> Catalan {
  if max_n < 0 {
    abort("max_n must be non-negative")
  }
  let size = max_n + 1
  let values = Array::make(size, 0L)
  values[0] = 1L
  for n in 1..<size {
    let mut sum : Int64 = 0L
    for left in 0..<n {
      sum = sum + values[left] * values[n - 1 - left]
    }
    values[n] = sum
  }
  Catalan::{ values, }
}

///|
/// Get the `n`-th Catalan number from the precomputed table.
///
/// # Parameters
/// - `self`: precomputed Catalan table.
/// - `n`: the index of the Catalan number.
///
/// # Returns
/// - `Int64`: the value `C_n`.
///
/// # Example
/// ```
/// let catalan = Catalan::new(10)
/// inspect(catalan.nth(10), content="16796")
/// ```
pub fn nth(self : Catalan, n : Int) -> Int64 {
  if n < 0 || n >= self.values.length() {
    abort("n is out of precomputed range")
  }
  self.values[n]
}

///|
/// Retrieve all precomputed Catalan numbers as an array.
///
/// # Parameters
/// - `self`: precomputed Catalan table.
///
/// # Returns
/// - `Array[Int64]`: Catalan numbers from `C_0` to `C_max`.
///
/// # Example
/// ```
/// let catalan = Catalan::new(4)
/// inspect(catalan.values(), content="[1, 1, 2, 5, 14]")
/// ```
pub fn values(self : Catalan) -> Array[Int64] {
  self.values
}

///|
/// Compute the `n`-th Catalan number on demand.
///
/// # Parameters
/// - `n`: the desired index. Must be non-negative.
///
/// # Returns
/// - `Int64`: the value `C_n`.
///
/// # Example
/// ```
/// inspect(catalan_number(3), content="5")
/// ```
pub fn catalan_number(n : Int) -> Int64 {
  Catalan::new(n).nth(n)
}
