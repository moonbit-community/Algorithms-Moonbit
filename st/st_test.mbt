///|
test "max query" {
  let arr = [1, 2, 3, 4, 5, 6, 1, 2]
  let st = from(arr, @cmp.maximum)
  inspect(st.query(1, 1), content="1")
  inspect(st.query(2, 8), content="6")
}
///|
test "min query" {
  let arr = [1, 2, 3, 4, 5, 6, 1, 2]
  let st = from(arr, @cmp.minimum)
  inspect(st.query(1, 1), content="1")
  inspect(st.query(2, 8), content="1")
}
///|
test "gcd query" {
  fn gcd(a: Int, b: Int) -> Int {
      if b==0 {
          a
      } else {
        gcd(b, a%b)
      }
    }
  let arr = [4, 8, 16, 24, 48, 3]
  let st = from(arr, gcd)
  inspect(st.query(1, 2), content="4")
  inspect(st.query(3, 5), content="8")
}
