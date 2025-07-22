///|
fn per_work(s : String) -> String {
  let mut res = "<"
  for i = 0; i < s.length(); i = i + 1 {
    res += "#"
    res += s.charcode_at(i).to_char().to_string()
  }
  res += "#>"
  res
}

///| Manacher's Algorithm (Longest Palindromic Substring)
/// 
/// # Parameters
/// 
/// - `str` : input string
/// 
/// # Returns
/// 
/// - `Int` : length of the longest palindromic substring
///
/// # Example
// / ```
// /   let s = "babad"
// /   inspect(manacher(s), content="3") // "bab" or "aba"
// /   
// /   let s2 = "cbbd"
// /   inspect(manacher(s2), content="2") // "bb"
// / ```
pub fn manacher(str : String) -> Int {
  let s = per_work(str)
  let n = s.length()
  let mut c = 0
  let mut r = 0
  let mut mx = 0
  let p = Array::make(n + 1, 0)
  for i = 1; i < n - 1; i = i + 1 {
    if i < r {
      p[i] = @cmp.minimum(r - i, p[2 * c - i])
    } else {
      p[i] = 1
    }
    while s.charcode_at(i - p[i]) == s.charcode_at(i + p[i]) {
      p[i] += 1
    }
    if i + p[i] > r {
      c = i
      r = i + p[i]
      mx = @cmp.maximum(mx, p[i])
    }
  }
  mx - 1
}
