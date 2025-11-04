///|
/// A simple iterative Cooley-Tukey FFT implementation for MoonBit.
///
/// The FFT transforms a vector of complex numbers between the time domain
/// and frequency domain in \(O(n \log n)\) time. This module also exposes a
/// convolution helper for multiplying integer polynomials using the FFT.
struct Complex {
  re : Double
  im : Double
}

///|
fn Complex::new(re : Double, im : Double) -> Complex {
  { re, im }
}

///|
fn Complex::add(self : Complex, other : Complex) -> Complex {
  { re: self.re + other.re, im: self.im + other.im }
}

///|
fn Complex::sub(self : Complex, other : Complex) -> Complex {
  { re: self.re - other.re, im: self.im - other.im }
}

///|
fn Complex::mul(self : Complex, other : Complex) -> Complex {
  {
    re: self.re * other.re - self.im * other.im,
    im: self.re * other.im + self.im * other.re,
  }
}

///|
fn Complex::scale(self : Complex, factor : Double) -> Complex {
  { re: self.re * factor, im: self.im * factor }
}

///|
fn Complex::real(self : Complex) -> Double {
  self.re
}

///|
fn Complex::from_angle(angle : Double) -> Complex {
  Complex::new(@math.cos(angle), @math.sin(angle))
}

///|
/// In-place iterative FFT.
///
/// The length of `values` must be a power of two. Set `invert = true` to run
/// the inverse transform.
pub fn fft(values : Array[Complex], invert : Bool) -> Array[Complex] {
  let n = values.length()
  if n == 0 {
    return values
  }
  if (n & (n - 1)) != 0 {
    abort("FFT length must be a power of two")
  }
  let a = values
  let mut j = 0
  for i = 1; i < n; i = i + 1 {
    let mut bit = n >> 1
    while (j & bit) != 0 {
      j = j ^ bit
      bit = bit >> 1
    }
    j = j ^ bit
    if i < j {
      let tmp = a[i]
      a[i] = a[j]
      a[j] = tmp
    }
  }
  let mut len = 2
  let pi = 3.141592653589793
  while len <= n {
    let ang = 2.0 * pi / len.to_double()
    let step = if invert { -ang } else { ang }
    let wlen = Complex::from_angle(step)
    for start = 0; start < n; start = start + len {
      let mut w = Complex::new(1.0, 0.0)
      for i = 0; i < len / 2; i = i + 1 {
        let u = a[start + i]
        let v = w.mul(a[start + i + len / 2])
        a[start + i] = u.add(v)
        a[start + i + len / 2] = u.sub(v)
        w = w.mul(wlen)
      }
    }
    len = len << 1
  }
  if invert {
    let inv_n = 1.0 / n.to_double()
    for i = 0; i < n; i = i + 1 {
      a[i] = a[i].scale(inv_n)
    }
  }
  a
}

///|
/// Multiply two integer polynomials using FFT-based convolution.
///
/// # Parameters
///
/// - `a` : coefficients of the first polynomial.
/// - `b` : coefficients of the second polynomial.
///
/// # Returns
///
/// - `Array[Int]` : coefficients of the product polynomial.
pub fn convolution(a : Array[Int], b : Array[Int]) -> Array[Int] {
  if a.length() == 0 || b.length() == 0 {
    return []
  }
  let mut n = 1
  let target = a.length() + b.length() - 1
  while n < target {
    n = n << 1
  }
  let mut fa : Array[Complex] = Array::make(n, Complex::new(0.0, 0.0))
  let mut fb : Array[Complex] = Array::make(n, Complex::new(0.0, 0.0))
  for i = 0; i < a.length(); i = i + 1 {
    fa[i] = Complex::new(a[i].to_double(), 0.0)
  }
  for i = 0; i < b.length(); i = i + 1 {
    fb[i] = Complex::new(b[i].to_double(), 0.0)
  }
  fa = fft(fa, false)
  fb = fft(fb, false)
  for i = 0; i < n; i = i + 1 {
    fa[i] = fa[i].mul(fb[i])
  }
  fa = fft(fa, true)
  let res : Array[Int] = Array::make(target, 0)
  for i = 0; i < target; i = i + 1 {
    let val = fa[i].real()
    res[i] = @math.round(val).to_int()
  }
  res
}
