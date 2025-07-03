///|
enum Prework {
  Util(p~ : Array[Int64])
  Nil
}

///|
pub(all) struct StringHash {
  n : Int
  mod : Int64
  base : Int64
  hash : Array[Int64]
  prework : Prework
}

///|
let empty_hash : StringHash = StringHash::{
  n: 0,
  mod: 998244353,
  base: 131,
  hash: Array::make(0, 0),
  prework: Prework::Nil,
}

///| Create a new StringHash object.
pub fn StringHash::new(
  mod~ : Int64 = 998244353,
  base~ : Int64 = 131,
  s : String
) -> StringHash {
  let n = s.length()
  if n == 0 {
    return empty_hash
  }
  let p = Array::make(n + 1, 0L)
  let h = Array::make(n + 1, 0L)
  p[0] = 1
  h[0] = 1
  for i = 1; i <= n; i = i + 1 {
    p[i] = p[i - 1] * base % mod
    h[i] = (h[i - 1] * base + (s[i - 1] - 'a' + 1).to_int64()) % mod
  }
  StringHash::{ n, mod, base, hash: h, prework: Util(p~) }
}

///|
type! Uninitialized String derive(Show)

///|
type! IndexOutOfBounds String derive(Show)

///| Get string hash value
/// 
/// Parameters
/// 
/// - `left~` : left boundary index
/// - `right~` : right boundary index
/// 
/// Returns
/// 
/// - `Int64` : hash value
///
/// Errors
///
/// - `IndexOutOfBounds` : index out of bounds
/// - `Uninitialized` : prework not initialized
///
/// Example
/// ```
/// let hash = StringHash::new("abc")
/// inspect!(sh.get_hash(0, 1), content="133") // hash of "ab" 
/// ```
pub fn StringHash::get_hash(
  self : StringHash,
  left~ : Int = 0,
  right~ : Int = self.n - 1
) -> Int64!Error {
  if left < 0 || right >= self.n {
    raise IndexOutOfBounds("Index out of bounds.")
  }
  let p = match self.prework {
    Util(p~) => p
    Nil => raise Uninitialized("Prework not initialized.")
  }
  (
    self.hash[right + 1] -
    self.hash[left] * p[right - left + 1] % self.mod +
    self.mod
  ) %
  self.mod
}