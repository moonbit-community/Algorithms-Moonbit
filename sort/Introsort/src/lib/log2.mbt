/// Calculate the logarithmic value with base 2 (rounded part)
///
/// Parameters:
/// * `n` : A positive integer that needs to be calculated
///
/// Example:
/// ```moonbit
/// inspect!(log2(8), content="3")   // 2^3=8
/// inspect!(log2(10), content="3")  // 2^3=8 ≤10 <16=2^4
/// ```
fn log2(n: Int) -> Int {
  let mut k = 0
  let mut m = n
  while m > 1 {
    m = m >> 1
    k = k + 1
  }
  k
}