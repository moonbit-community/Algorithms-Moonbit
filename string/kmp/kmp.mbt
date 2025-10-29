// get next array

///|
fn getNext(t : String) -> Array[Int] {
  let n = t.length()
  let mut k = 0
  let mut i = 1
  let nextp = Array::make(n + 1, 0)
  nextp[0] = -1
  while i < n - 1 {
    if k == -1 || t[k] == t[i] {
      i += 1
      k += 1
      if t[k] == t[i] {
        nextp[i] = nextp[k]
      } else {
        nextp[i] = k
      }
    } else {
      k = nextp[k]
    }
  }
  nextp
}

///|
/// KMP
/// 
/// # Parameters
/// 
/// - `s` : text string
/// - `t` : pattern string
/// 
/// # Returns
/// 
/// - `Array[Int]` : All start position that t appear in s
///
/// # Example
/// ```
///   let s = "ABABABC"
///   let t = "ABA"
///   inspect(@kmp.kmp(s, t), content="[1, 3]")
/// ```
pub fn kmp(s : String, t : String) -> Array[Int] {
  let next = getNext(t)
  let pos : Array[Int] = []
  let mut i = 0
  let mut j = 0
  let n1 = s.length()
  let n2 = t.length()
  while i < n1 {
    j = 0
    while i < n1 && j < n2 {
      if j == -1 || s[i] == t[j] {
        i += 1
        j += 1
      } else {
        j = next[j]
      }
    }
    if j >= n2 {
      i = i - n2 + 1
      pos.push(i)
    } else {
      break
    }
  }
  pos
}

// get z array of s

///|
fn get_z(s : String) -> Array[Int] {
  let n = s.length()
  let mut l = 0
  let mut r = -1
  let z = Array::make(n, 0)
  z[0] = n
  for i = 1; i < n; i = i + 1 {
    if i <= r {
      z[i] = @cmp.minimum(z[i - l], r - i + 1)
    }
    while i + z[i] < n && s[z[i]] == s[i + z[i]] {
      z[i] += 1
    }
    if i + z[i] - 1 > r {
      l = i
      r = i + z[i] - 1
    }
  }
  z
}

///|
/// Z function (maximum PLC)
/// 
/// # Parameters
/// 
/// - `s` : text string
/// - `t~` : pattern string
/// 
/// # Returns
/// 
/// - `Array[Int]` : z function of (s) or (t for s)
///
/// # Example
/// ```
///   let a = "aaaabaa"
///   let b = "aaaaa"
///   inspect(z_func(b), content="[5, 4, 3, 2, 1]")
///   inspect(z_func(b, t=a), content="[4, 3, 2, 1, 0, 2, 1]")
/// ```
pub fn z_func(s : String, t? : String = "") -> Array[Int] {
  let z : Array[Int] = get_z(s)
  match t {
    "" => z
    _ => {
      let n = s.length()
      let m = t.length()
      let q = Array::make(m, 0)
      let mut l = 0
      let mut r = -1
      for i = 0; i < m; i = i + 1 {
        if i <= r {
          q[i] = @cmp.minimum(z[i - l], r - i + 1)
        }
        while q[i] < n && i + q[i] < m && s[q[i]] == t[i + q[i]] {
          q[i] += 1
        }
        if i + q[i] - 1 > r {
          l = i
          r = i + q[i] - 1
        }
      }
      q
    }
  }
}
