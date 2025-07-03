///|
enum Prework {
  Util(Array[Int64])
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
impl StringHash {
  pub fn new( 
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
    h[0] = 0
    for i = 1; i <= n; i = i + 1 {
      p[i] = p[i - 1] * base % mod
      h[i] = (h[i - 1] * base + (s.charcode_at(i - 1)).to_int64()) % mod
    }
    StringHash::{ n, mod, base, hash: h, prework: Prework::Util(p) }
  }

///|
suberror Uninitialized String derive(Show)

///|
suberror IndexOutOfBounds String derive(Show)

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
  /// test {
  ///   let sh = StringHash::new("abc")
  ///   inspect(sh.get_hash(0, 1), content="133") // hash of "ab" 
  /// }
  /// ```
 pub fn get_hash(
  self, 
  left : Int, 
  right? : Int
) -> Int64 raise (Uninitialized | IndexOutOfBounds) {
    let right = right.get_or_default(self.n - 1)

    if left < 0 || right >= self.n || left > right {
      raise IndexOutOfBounds("Index out of bounds.")
    }
    let p = match self.prework {
      Util(p) => p
      Nil => raise Uninitialized("Prework not initialized.")
    }
    (self.hash[right + 1] - 
    self.hash[left] * p[right - left + 1] % self.mod + 
    self.mod
    ) % 
    self.mod
  }
}