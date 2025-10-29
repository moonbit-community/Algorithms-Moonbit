///|
test "sequence prefix" {
  let catalan = Catalan::new(15)
  inspect(
    catalan.values(),
    content="[1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845]",
  )
}

///|
test "on demand computation" {
  inspect(catalan_number(0), content="1")
  inspect(catalan_number(1), content="1")
  inspect(catalan_number(2), content="2")
  inspect(catalan_number(3), content="5")
  inspect(catalan_number(7), content="429")
  inspect(catalan_number(10), content="16796")
}

///|
test "recurrence and large values" {
  let catalan = Catalan::new(35)
  let mut convolution : Int64 = 0L
  for left in 0..<6 {
    convolution = convolution + catalan.nth(left) * catalan.nth(5 - left)
  }
  inspect(convolution, content="132")
  inspect(catalan.nth(20), content="6564120420")
  inspect(catalan.nth(35), content="3116285494907301262")
}
