fn kmp_index(a : String, b : String) -> Array[Int] {
  let n = a.length()
  let m = b.length()
  let mut maxsize = n
  if m > n {
    maxsize = m
  }
  let nxt : Array[Int] = Array::make(maxsize, 0)
  let tmp : Array[Int] = Array::make(maxsize, 0)
  let mut s : String = a
  let mut t : String = b
  s = "-" + s
  t = "-" + t
  let mut i = 2
  let mut j = 0
  while i <= m {
    while j != 0 && t[j] != t[j + 1] {
      j = nxt[j]
    }
    if t[j] == t[j + 1] {
      j = j + 1
    }
    nxt[i] = j
    i = i + 1
  }
  i = 1
  j = 0
  let mut idx = 0
  while i <= n {
    while j != 0 && s[i] != t[j + 1] {
      j = nxt[j]
    }
    if s[i] == t[j + 1] {
      j = j + 1
    }
    if (j == m) {
      tmp[idx] = i - m + 1
      idx = idx + 1
      j = nxt[j]
    }
    i = i + 1
  }
  let ans : Array[Int] = Array::make(idx, 0)
  for i = 0; i < idx; i = i + 1 {
    ans[i] = tmp[i]
  }
  ans
}

test {
  assert_eq!(kmp_index("abcdef", "bcd"), [2])
  assert_eq!(kmp_index("abcdef", "tyu"), [])
  assert_eq!(kmp_index("abcdeabcabab", "ab"), [1, 6, 9, 11])
}