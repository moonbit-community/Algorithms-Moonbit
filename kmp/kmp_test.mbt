test "kmp" {
  let s = "ABABABC"
  let t = "ABA"
  inspect!(@kmp.kmp(s, t), content="[1, 3]")
}


test "z_func" {
  let a = "aaaabaa"
  let b = "aaaaa"
  inspect!(@kmp.z_func(b), content="[5, 4, 3, 2, 1]")
  inspect!(@kmp.z_func(b, t = a), content="[4, 3, 2, 1, 0, 2, 1]")
}