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

///|
/// Create a new StringHash object.
pub fn StringHash::new(
  mod~ : Int64 = 998244353,
  base~ : Int64 = 131,
  s : String,
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
priv suberror Uninitialized String derive(Show)

///|
priv suberror IndexOutOfBounds String derive(Show)

///|
/// Get string hash value
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
/// let sh = StringHash::new("abc")
/// inspect(sh.get_hash(left_idx = 0, right_idx = 1), content="133") // hash of "ab" 
/// ```
pub fn StringHash::get_hash(
  self : StringHash,
  left_idx? : Int,
  right_idx? : Int,
) -> Int64 raise Error {
  let left = match left_idx {
    Some(l) => l
    None => 0
  }
  let right = match right_idx {
    Some(r) => r
    None => self.n - 1
  }
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
