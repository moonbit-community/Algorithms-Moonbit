///|
test "sort matches the standard sort across representative inputs" {
  for size in [0, 1, 2, 16, 31, 64] {
    for pattern in 0..<4 {
      let values = Array::makei(size, i => {
        match pattern {
          0 => size - i
          1 => i % 7 - 3
          2 => if i % 2 == 0 { i } else { -i }
          _ => i
        }
      })
      let expected = values.copy()
      expected.sort()
      sort(values)
      assert_true(values == expected)
    }
  }
}
