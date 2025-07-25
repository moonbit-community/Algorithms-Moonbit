///| Calculate the logarithmic value with base 2 (rounded part)
///
/// Parameters:
/// * `n` : A positive integer that needs to be calculated
///
fn log2(n : Int) -> Int {
  let mut k = 0
  let mut m = n
  while m > 1 {
    m = m >> 1
    k += 1
  }
  k
}
