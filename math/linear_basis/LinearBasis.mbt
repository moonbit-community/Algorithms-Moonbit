///|
struct LinearBasis {
  basis : Array[Int64]
  max_bits : Int
}

///|
/// Construct an empty linear basis over XOR with a fixed bit width.
///
/// # Parameters
/// - `max_bits`: maximum number of bits considered for input values.
///
/// # Returns
/// - `LinearBasis`: an empty XOR basis ready for insertions.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(60)
/// inspect(basis.dimension(), content="0")
/// ```
pub fn LinearBasis::new(max_bits : Int) -> LinearBasis {
  if max_bits <= 0 {
    abort("max_bits must be positive")
  }
  let basis = Array::make(max_bits, 0L)
  { basis, max_bits }
}

///|
/// Insert a value into the linear basis if it is linearly independent.
///
/// # Parameters
/// - `self`: current basis.
/// - `value`: value to be added.
///
/// # Returns
/// - `Bool`: `true` when the value expands the basis, `false` otherwise.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// inspect(basis.insert(3L), content="true")
/// inspect(basis.insert(3L), content="false")
/// ```
pub fn LinearBasis::insert(self : LinearBasis, value : Int64) -> Bool {
  let mut x : Int64 = value
  for idx in 0..<self.max_bits {
    let bit = self.max_bits - 1 - idx
    let shifted = bit
    if ((x >> shifted) & 1L) == 0L {
      continue
    }
    if self.basis[bit] == 0L {
      self.basis[bit] = x
      return true
    }
    x = x ^ self.basis[bit]
  }
  false
}

///|
/// Reduce a value with the current basis to its canonical representative.
///
/// # Parameters
/// - `self`: current basis.
/// - `value`: value to be reduced.
///
/// # Returns
/// - `Int64`: the reduced value after eliminating basis components.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// let _ = basis.insert(3L)
/// inspect(basis.reduce(3L), content="0")
/// ```
pub fn LinearBasis::reduce(self : LinearBasis, value : Int64) -> Int64 {
  let mut x = value
  for idx in 0..<self.max_bits {
    let bit = self.max_bits - 1 - idx
    let shifted = bit
    if ((x >> shifted) & 1L) == 0L {
      continue
    }
    if self.basis[bit] != 0L {
      x = x ^ self.basis[bit]
    }
  }
  x
}

///|
/// Query the maximum achievable XOR value with an optional seed.
///
/// # Parameters
/// - `self`: current basis.
/// - `seed`: initial value to enhance. Use `0` for the pure basis maximum.
///
/// # Returns
/// - `Int64`: the maximal XOR obtainable with the stored basis vectors.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// let _ = basis.insert(3L)
/// let _ = basis.insert(6L)
/// inspect(basis.max_xor(0L), content="6")
/// ```
pub fn LinearBasis::max_xor(self : LinearBasis, seed : Int64) -> Int64 {
  let mut result = seed
  for idx in 0..<self.max_bits {
    let bit = self.max_bits - 1 - idx
    let candidate = result ^ self.basis[bit]
    if candidate > result {
      result = candidate
    }
  }
  result
}

///|
/// Count the number of basis vectors currently stored.
///
/// # Parameters
/// - `self`: current basis.
///
/// # Returns
/// - `Int`: the rank (dimension) of the basis.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// let _ = basis.insert(1L)
/// let _ = basis.insert(2L)
/// let _ = basis.insert(3L)
/// inspect(basis.dimension(), content="2")
/// ```
pub fn LinearBasis::dimension(self : LinearBasis) -> Int {
  let mut count = 0
  for bit in 0..<self.max_bits {
    if self.basis[bit] != 0L {
      count = count + 1
    }
  }
  count
}

///|
/// Check whether a value can be represented by the current basis.
///
/// # Parameters
/// - `self`: current basis.
/// - `value`: value to test.
///
/// # Returns
/// - `Bool`: `true` if the value lies in the span of the basis, `false` otherwise.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// let _ = basis.insert(5L)
/// let _ = basis.insert(10L)
/// inspect(basis.contains(15L), content="true")
/// ```
pub fn LinearBasis::contains(self : LinearBasis, value : Int64) -> Bool {
  self.reduce(value) == 0L
}

///|
/// Expose the internal basis array for inspection or debugging.
///
/// # Parameters
/// - `self`: current basis.
///
/// # Returns
/// - `Array[Int64]`: snapshot of all stored basis vectors by leading bit.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(4)
/// inspect(basis.vectors().length(), content="4")
/// ```
pub fn LinearBasis::vectors(self : LinearBasis) -> Array[Int64] {
  self.basis
}

///|
/// Query the k-th largest achievable XOR value.
///
/// The ordering is descending and includes the zero vector as the last element.
/// For example, in a basis spanning values `{0, 1, 2, 3}`, the results are
/// `k=1 -> 3`, `k=2 -> 2`, `k=3 -> 1`, and `k=4 -> 0`.
///
/// # Parameters
/// - `self`: current basis.
/// - `k`: 1-indexed rank of the desired value as an `Int`. Must satisfy `1 <= k <= 2^rank`.
///
/// # Returns
/// - `Int64`: the k-th largest value representable by the basis.
///
/// # Example
/// ```
/// let basis = LinearBasis::new(5)
/// let _ = basis.insert(1L)
/// let _ = basis.insert(2L)
/// inspect(basis.kth_largest(1), content="3")
/// inspect(basis.kth_largest(3), content="1")
/// ```
pub fn LinearBasis::kth_largest(self : LinearBasis, k : Int) -> Int64 {
  let vectors = LinearBasis::canonical_vectors(self)
  let rank = vectors.length()
  let shift = rank
  if shift >= 63 {
    abort("basis rank too large to enumerate")
  }
  if k <= 0 {
    abort("k must be positive")
  }
  let total = 1L << shift
  let k64 = Int64::from_int(k)
  if k64 > total {
    abort("k exceeds number of representable values")
  }
  let index = total - k64
  let mut value = 0L
  for idx in 0..<rank {
    let vector = vectors[idx]
    let bit_shift = rank - 1 - idx
    if ((index >> bit_shift) & 1L) != 0L {
      value = value ^ vector
    }
  }
  value
}

///|
fn LinearBasis::canonical_vectors(self : LinearBasis) -> Array[Int64] {
  let rank = self.dimension()
  let ordered = Array::make(rank, 0L)
  let mut index = 0
  for idx in 0..<self.max_bits {
    let bit = self.max_bits - 1 - idx
    let value = self.basis[bit]
    if value != 0L {
      ordered[index] = value
      index = index + 1
    }
  }
  for i in 0..<rank {
    let mut current = ordered[i]
    for j in 0..<i {
      let candidate = current ^ ordered[j]
      if candidate < current {
        current = candidate
      }
    }
    ordered[i] = current
    for j in 0..<i {
      let candidate = ordered[j] ^ current
      if candidate < ordered[j] {
        ordered[j] = candidate
      }
    }
  }
  ordered
}
