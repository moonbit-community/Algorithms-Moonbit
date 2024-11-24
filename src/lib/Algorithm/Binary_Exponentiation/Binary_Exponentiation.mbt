fn bin_pow(x : Int64, y : Int64) -> Int64 {
  let mut res : Int64 = 1
  let mut a : Int64 = x
  let mut n : Int64 = y
  while n > 0 {
    if n % 2 == 1 {
      res = res * a
    }
    a = a * a
    n = n >> 1
  }
  res
}

fn bin_pow_mod(x : Int64, y : Int64, z : Int64) -> Int64 {
  let mut res : Int64 = 1
  let mut a : Int64 = x
  let mut n : Int64 = y
  let m : Int64 = z
  if m <= 0 {
    abort(
      "ModulosNumberError: The number of modulos should be a positive integer",
    )
  }
  a = a % m
  while n > 0 {
    if n % 2 == 1 {
      res = res * a % m
    }
    a = a * a % m
    n = n >> 1
  }
  res
}

test {
  assert_eq!(bin_pow(2, 3), 8)
  assert_eq!(bin_pow(2, 1), 2)
  assert_eq!(bin_pow(2, 0), 1)
  assert_eq!(bin_pow(15, 20), 4664335276710460609)
  assert_eq!(bin_pow_mod(15, 20, 1000000007), 393128630)
  assert_eq!(bin_pow_mod(2, 3, 3), 2)
}
