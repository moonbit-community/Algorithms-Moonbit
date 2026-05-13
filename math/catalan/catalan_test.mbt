///|
test "sequence prefix" {
  let catalan = Catalan::new(15)
  debug_inspect(
    catalan.values(),
    content="[\n  1,\n  1,\n  2,\n  5,\n  14,\n  42,\n  132,\n  429,\n  1430,\n  4862,\n  16796,\n  58786,\n  208012,\n  742900,\n  2674440,\n  9694845,\n]",
  )
}

///|
test "on demand computation" {
  debug_inspect(catalan_number(0), content="1")
  debug_inspect(catalan_number(1), content="1")
  debug_inspect(catalan_number(2), content="2")
  debug_inspect(catalan_number(3), content="5")
  debug_inspect(catalan_number(7), content="429")
  debug_inspect(catalan_number(10), content="16796")
}

///|
test "recurrence and large values" {
  let catalan = Catalan::new(35)
  let mut convolution : Int64 = 0L
  for left in 0..<6 {
    convolution = convolution + catalan.nth(left) * catalan.nth(5 - left)
  }
  debug_inspect(convolution, content="132")
  debug_inspect(catalan.nth(20), content="6564120420")
  debug_inspect(catalan.nth(35), content="3116285494907301262")
}
